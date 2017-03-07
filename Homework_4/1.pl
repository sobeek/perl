#! usr/bin/env/perl -l

use strict;
use warnings;
use DDP;

$/ = "\n";

my $f = './access.log';
my %log = ();
my ($ip, $time, $request, $code, $compressed_bytes, $referrer, $user_agent, $coeff);

sub data_by_codes {
    my ($ip, $code, $compressed_bytes, $coeff) = @_;
    my $compressed_kilobytes = $compressed_bytes / 1024;
    $log{$ip}{compressed_data_by_code}{$code} += $compressed_kilobytes;
    if (200 == $code) {

#CHANGE 0 TO 1 AFTER DISCUSSION!

        $coeff = 0 if $coeff !~ /\d+(\.\d+)*/;
        $log{$ip}{uncompressed_data_200} += $compressed_kilobytes * $coeff;
    }

}

sub avg_time {
    my ($count, $count_per_second) = @_;
    return $count / $count_per_second;
}

sub round {
    my $bytes = $_[0] || 0;
    my $dot_index = index ($bytes, ".");
    return $dot_index > -1 ? substr ($bytes, 0, $dot_index) : 0;
}

open F, $f or die "$!";
while (<F>) {
    chomp;
    ($ip, $time, $request, $code, $compressed_bytes, $referrer, $user_agent, $coeff) =
    /(.*?)\s\[(.*?)\]\s"(.*)"\s(\d+)\s(\d+)\s"(.*?)"\s"(.*?)"\s"(.*?)"/;

    for ('total', $ip) {
        ++$log{$_}{count};
        my $ip_ct = $log{$_}->{current_time} || 0;
        if ($ip_ct ne $time) {
            $log{$_}{current_time} = $time;
            ++$log{$_}{count_per_second}
        }
        data_by_codes ($_, $code, $compressed_bytes, $coeff);
    }
}

for (keys %log) {
    my $current_ip = $log{$_};
    $current_ip->{avg_time} = avg_time ($current_ip->{count}, $current_ip->{count_per_second});
}

my @codes = sort {$a <=> $b} keys $log{total}{compressed_data_by_code};

$, = "\t";
print qw/IP  count   avg data    data_200    data_301    data_302    data_400    data_403    data_404    data_408    data_414    data_499    data_500/;

my @sorted = (sort {$log{$b}{count} <=> $log{$a}{count}} keys %log)[0..10];
for (@sorted) {
    my $current_ip = $log{$_};
    my $kb_codes = join "\t", map {my $x = $current_ip->{compressed_data_by_code}{$_} || 0; round($x) if $x} @codes;
    print ($_, $current_ip->{count}, $current_ip->{avg_time}, round ($current_ip->{uncompressed_data_200}), $kb_codes);
    print $_;
    p $log{$_};
}
