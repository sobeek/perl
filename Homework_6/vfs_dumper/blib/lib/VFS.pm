#!/usr/bin/perl -l
package VFS;
use DDP;
use strict;
use warnings;
use 5.010;
use JSON;
use Encode qw/encode decode/;

my $bin_string;
#my $fh;

my $unpacking_patterns = {
    name_length => {bytes => 2, pattern => "C2"},
    name => {bytes => "will get it later", pattern => "A"},
    mode => {bytes => 2, pattern => "B16"},
    size => {bytes => 4, pattern => "N4"},
    hash => {bytes => 20, pattern => "H40"}
};

my $unpacking_fields_file = ["name_length", "name", "mode", "size", "hash"];
my $unpacking_fields_dir = ["name_length", "name", "mode"];

sub parse {
    $bin_string = shift;
    #my $res = ;
    #p $res;
    return vfs_dumper();
}

sub parser {
    my ($type, $current_pos) = @_;
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
            #print 11111;
            $bytes_to_read = 0+$read[-1];
            $pattern = $unpacking_patterns->{name}{pattern}.$bytes_to_read;
            #print $pattern;
            #<>;
            pop @read;
            $need_to_decode = 1;
        }
        else {
            $bytes_to_read = $unpacking_patterns->{$_}{bytes};
            $pattern = $unpacking_patterns->{$_}{pattern};
        }

        $buf = substr $bin_string, 0, $bytes_to_read, '';
        $unpacked = join '', unpack $pattern, $buf;
        #warn "$unpacked";
        #<>;
        $unpacked = decode('utf8', $unpacked) if $need_to_decode;
        #warn $unpacked;
        push @read, $unpacked;
        #++$i;
        #last if $i > $#patt;
    }
    #warn "@read";
    $result->{type} = $type;
    if ('file' eq $type) {
        $result->{hash} = pop @read;
        $result->{size} = pop @read;
    }
    $result->{mode} = mode2s (pop @read);
    $result->{name} = pop @read;
    #warn $result->{name};
    return $result #, $current_pos);
}

sub parse_dir {
    #my $current_pos = shift;
    #my $parsed_dir;
    #$parsed_dir = ; #, $current_pos);
    return parser('directory') #, $current_pos);
}

sub parse_file {
    #my $current_pos = shift;
    #my $parsed_file;
    #$parsed_file = ; #, $current_pos);
    return parser('file'); #, $current_pos);
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
            #p $chopped;
            $gr->{$_} = $json_bool;
        }
    }
    return {other => $other, group => $group, user => $user};
}

sub vfs_dumper;

sub vfs_dumper {
    #print $fh;
    #my $current_pos = shift // 0;
    my $current_dir = [];
    #while (sysread $bin_string, my $buf, 1) {
    while (my $buf = substr $bin_string, 0, 1, '') {
        my $command = join '', unpack "A1", $buf;
        #++$current_pos;
        #print $command;
        given ($command) {
            when ('D') {
                my $res;
                #($res, $current_pos)
                $res = parse_dir(); #$current_pos);
                #print $current_pos;
                #<>;
                #p $res;
                $res->{list} = vfs_dumper(); #$current_pos);
                push @$current_dir, $res;
            }
            when ('F') {
                #print "Parsing file...";
                #my $res;
                #($res, $current_pos)
                #$res = ; #$current_pos);
                #p $res;
                #print "Parsing of the file is done!";
                push @$current_dir, parse_file();
                #next
            }
            when ([qw(I Z)]) {

            }
            when ('U') {
                return $current_dir;
            }
            default {
                die "WHAT??";
            }
        }
    }
    #print ref $current_dir;
    #<>;
    return shift @$current_dir
}

1;
