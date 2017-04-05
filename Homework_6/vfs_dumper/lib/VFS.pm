package VFS;

use strict;
use warnings;
use 5.010;
use JSON;
use Encode qw/encode decode/;

my $bin_string;

my $unpacking_patterns = {
    name_length => {bytes => 2, pattern => "C2"},
    name => {bytes => "will get it later", pattern => "A"},
    mode => {bytes => 2, pattern => "B16"},
    size => {bytes => 4, pattern => "N4"},
    hash => {bytes => 20, pattern => "H40"}
};

my $unpacking_fields_file = ["name_length", "name", "mode", "size", "hash"];
my $unpacking_fields_dir = ["name_length", "name", "mode"];

my $wait_first;

sub parse {
    $bin_string = shift;
    $wait_first = 1;
    return vfs_dumper();
}

sub parser {
    my ($type) = @_;
    my $unpacking_fields;
    given ($type) {
        when ('file') {
            $unpacking_fields = $unpacking_fields_file;
        }
        when ('directory') {
            $unpacking_fields = $unpacking_fields_dir;
        }
        default {
            die "UNKNOWN TYPE";
        }
    }
    my $result = {};
    my @read = ();
    my $pattern;
    my $bytes_to_read;
    my $need_to_decode = 0;
    my $unpacked;
    my $buf;
    for (@$unpacking_fields) {
        if ("name" eq $_) {
            $bytes_to_read = 0+$read[-1];
            $pattern = $unpacking_patterns->{name}{pattern}.$bytes_to_read;
            pop @read;
            $need_to_decode = 1;
        }
        else {
            $bytes_to_read = $unpacking_patterns->{$_}{bytes};
            $pattern = $unpacking_patterns->{$_}{pattern};
        }
        $buf = substr $bin_string, 0, $bytes_to_read, '';
        $unpacked = join '', unpack $pattern, $buf;
        $unpacked = decode('utf8', $unpacked) if $need_to_decode;
        push @read, $unpacked;
    }
    $result->{type} = $type;
    if ('file' eq $type) {
        $result->{hash} = pop @read;
        $result->{size} = pop @read;
    }
    $result->{mode} = mode2s (pop @read);
    $result->{name} = pop @read;
    return $result
}

sub parse_dir {
    return parser('directory')
}

sub parse_file {
    return parser('file')
}

sub mode2s {
    my $mode = shift;
    my $other = {};
    my $group = {};
    my $user = {};
    my @gr = ($other, $group, $user);
    my @mod = qw/execute write read/;
    for my $gr (@gr) {
        for (@mod) {
            my $chopped = chop $mode;
            my $json_bool = $chopped ? JSON::true($chopped) : JSON::false($chopped);
            $gr->{$_} = $json_bool;
        }
    }
    return {other => $other, group => $group, user => $user};
}

sub vfs_dumper;

sub vfs_dumper {
    my $current_dir = [];
    while (my $buf = substr $bin_string, 0, 1, '') {
        my $command = join '', unpack "A1", $buf;
        if ($wait_first) {
            if ($command ne 'D' && $command ne 'Z') {
                die "The blob should start from 'D' or 'Z'" ;
            }
            $wait_first = 0;
        }
        given ($command) {
            when ('D') {
                my $res;
                $res = parse_dir();
                $res->{list} = vfs_dumper();
                push @$current_dir, $res;
            }
            when ('F') {
                push @$current_dir, parse_file();
            }
            when ('I') {
                next
            }
            when ('Z') {
                last
            }
            when ('U') {
                return $current_dir;
            }
            default {
                die "WHAT??";
            }
        }
    }
    die "Garbage ae the end of the buffer" if $bin_string;
    return shift @$current_dir // {};
}

1;
