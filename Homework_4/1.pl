#! usr/bin/env/perl -l

use strict;
use warnings;
use DDP;
use Date::Parse;

$/ = "\n";

my $f = './access.log';
#my $f = './1';
my %log = ();
#my $data = {};
my ($ip, $time, $request, $code, $compressed_bytes, $referrer, $user_agent, $coeff);

sub set_time {
    my ($ip, $time) = @_;
    my $what_time = exists $log{$ip}{first_time} ? 'last_time' : 'first_time';
    $log{$ip}{$what_time} = $time;
}

sub data_by_codes {
    my ($code, $compressed_bytes, $coeff) = @_;
    if (200 == $code) {
        #my $data = $log{$ip}{data};
        $coeff = $coeff =~ /^\d+\.?\d*$/ ? $coeff : 1;
        $log{$ip}{uncompressed_data_200} += $compressed_bytes * $coeff;
    }
    $log{$ip}{compressed_data_by_code}{$code} += $compressed_bytes;
}

sub avg_time {
    my ($first_time, $last_time, $count) = @_;

    my $first_time_unix = str2time($first_time);
    my $last_time_unix = str2time($last_time) || $first_time_unix;
    #print $first_time_unix, "\n", $last_time_unix if $last_time_unix;
    $_ = ($last_time_unix - $first_time_unix) / (60 * $count);
    return (/(\d+\.\d{1,2})/) ? $1 : $_;

    #$last_time_unix ? return ($last_time_unix - $first_time_unix) / (60 * $count) : 0;
}

sub round {
    my $bytes = $_[0] || 0;
    #print $bytes;
    my $dot_index = index ($bytes, ".");
    return $dot_index > -1 ? substr ($bytes, 0, $dot_index) : 0;
}

open F, $f or die "$!";
while (<F>) {
    chomp;
    ($ip, $time, $request, $code, $compressed_bytes, $referrer, $user_agent, $coeff) =
    /(.*?)\s\[(.*?)\]\s"(.*)"\s(\d+)\s(\d+)\s"(.*?)"\s"(.*?)"\s"(.*?)"/;
    
    ++$log{$ip}{count};
    set_time($ip, $time);
    data_by_codes ($code, $compressed_bytes, $coeff);

    ++$log{total}{count};
    $log{total}{first_time} = $time if $. == 1;
    $log{total}{last_time} = $time if eof;
}

for (keys %log) {
    my $current_ip = $log{$_};
    $current_ip->{avg_time} = avg_time ($current_ip->{first_time}, $current_ip->{last_time}, $current_ip->{count});
    $log{total}{uncompressed_data_200} += $current_ip->{uncompressed_data_200} if exists $current_ip->{uncompressed_data_200};
    for my $key (keys $current_ip->{compressed_data_by_code}) {
        $log{total}{compressed_data_by_code}{$key} += $current_ip->{compressed_data_by_code}{$key};
    }

}
my @codes = sort {$a <=> $b} keys $log{total}{compressed_data_by_code};

$, = "\t";
print qw/IP  count   avg data    data_200    data_301    data_302    data_400    data_403    data_404    data_408    data_414    data_499    data_500/;

my @sorted = (sort {$log{$b}{count} <=> $log{$a}{count}} keys %log)[0..10];
for (@sorted) {
    my $current_ip = $log{$_};
    my $codes = join "\t", map {$current_ip->{compressed_data_by_code}{$_} || 0} @codes;
    print ($_, $current_ip->{count}, $current_ip->{avg_time}, round ($current_ip->{uncompressed_data_200}), $codes );
    #p $log{$_};
}
