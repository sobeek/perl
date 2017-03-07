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
    my ($ip, $code, $compressed_bytes, $coeff) = @_;
    $log{$ip}{compressed_data_by_code}{$code} += $compressed_bytes / 1024;
    if (200 == $code) {
        #my $data = $log{$ip}{data};
        #$coeff = $coeff =~ /^\d+\.?\d*$/ ? $coeff : 1;
        my $is_num_coeff = 0+$coeff;
        print $is_num_coeff;
        $log{$ip}{uncompressed_data_200} += $compressed_bytes * $is_num_coeff / 1024;
    }

}

sub avg_time_old {
    my ($first_time, $last_time, $count) = @_;

    my $first_time_unix = str2time($first_time);
    my $last_time_unix = str2time($last_time) || $first_time_unix;
    #print $first_time_unix, "\n", $last_time_unix if $last_time_unix;
    $_ = ($last_time_unix - $first_time_unix) * $count / 60;
    return (/(\d+\.\d{1,2})/) ? $1 : $_;

    #$last_time_unix ? return ($last_time_unix - $first_time_unix) / (60 * $count) : 0;
}

sub avg_time {
    my ($count, $count_per_second) = @_;
    return $count / $count_per_second;
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

    #$log{$current_time} = $time;

    for ('total', $ip) {
        ++$log{$_}{count};
        my $ip_ct = $log{$_}->{current_time} || 0;
        if ($ip_ct ne $time) {
            $log{$_}{current_time} = $time;
            ++$log{$_}{count_per_second}
        }
        data_by_codes ($_, $code, $compressed_bytes, $coeff);
    }

    #set_time($ip, $time);


    #$log{total}{first_time} = $time if $. == 1;
    #$log{total}{last_time} = $time if eof;
}




for (keys %log) {
    my $current_ip = $log{$_};
    #next if $current_ip eq 'total';
    #$current_ip->{avg_time} = avg_time ($current_ip->{first_time}, $current_ip->{last_time}, $current_ip->{count});
    $current_ip->{avg_time} = avg_time ($current_ip->{count}, $current_ip->{count_per_second});
    #$current_ip->{uncompressed_data_200} /= 1024 if exists $current_ip->{uncompressed_data_200};
    #for my $key (keys $current_ip->{compressed_data_by_code}) {
    #    $current_ip->{compressed_data_by_code}{$key} /= 1024;# $current_ip->{compressed_data_by_code}{$key};
    #}
}


#$log{$_}{avg_time} = avg_time ($log{$_}{count}, $log{$_}{count_per_second}) for keys %log;

my @codes = sort {$a <=> $b} keys $log{total}{compressed_data_by_code};

$, = "\t";
print qw/IP  count   avg data    data_200    data_301    data_302    data_400    data_403    data_404    data_408    data_414    data_499    data_500/;

my @sorted = (sort {$log{$b}{count} <=> $log{$a}{count}} keys %log)[0..10];
for (@sorted) {
    my $current_ip = $log{$_};
    my $codes = join "\t", map {$current_ip->{compressed_data_by_code}{$_} || 0} @codes;
    #print ($_, $current_ip->{count}, $current_ip->{avg_time}, round ($current_ip->{uncompressed_data_200}), $codes );
    print $_;
    p $log{$_};
}
