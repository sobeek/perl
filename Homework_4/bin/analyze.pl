#! usr/bin/env/perl

use strict;
use warnings;

$/ = "\n";
my $separator = "\t";

my $filepath = $ARGV[0];
die "USAGE:\n$0 <log-file.bz2>\n"  unless $filepath;
die "File '$filepath' not found\n" unless -f $filepath;

my %log = ();

my $patt = qr /
            ^(?<ip>.*?)\s
            \[(?<time>[^\]]*)\]\s
            "(?<request>[^"]*)"\s
            (?<code>\d+)\s
            (?<compressed_bytes>\d+)\s
            "(?<referrer>[^"]*)"\s
            "(?<user_agent>[^"]*)"\s
            "(?<coeff>\d+(?:\.\d+)*|-)"$
            /x;

my $parsed_data = parse_file($filepath);
report($parsed_data);
exit;

sub data_by_codes {
    my ($ip, $code, $compressed_bytes, $coeff) = @_;
    #my $compressed_kilobytes = $compressed_bytes / 1024;
    #$log{$ip}{compressed_data_by_code}{$code} += $compressed_kilobytes;

    #rounding and transforming to KBytes is performing at output

    $log{$ip}{compressed_data_by_code}{$code} += $compressed_bytes;
    if (200 == $code) {
        #$coeff = 1 if $coeff !~ /\d+(\.\d+)*/;
        $coeff = 1 if $coeff eq '-'; #very probably it is ok
        #$log{$ip}{uncompressed_data_200} += $compressed_kilobytes * $coeff;
        $log{$ip}{uncompressed_data_200} += $compressed_bytes * $coeff;
    }
}

sub avg_time {
    my ($count, $count_per_minute) = @_;
    return sprintf ("%.2f", $count / $count_per_minute)
}

sub parse_file {
    my $file = shift;
    my $result;
    open my $fd, "-|", "bunzip2 < $file" or die "Can't open '$file': $!";

    while (my $log_line = <$fd>) {
        my @data = ();
        my $invalid_line = 0;
        chomp $log_line;

        if ($log_line !~ $patt) {
            ++$log{total}{count};
            next;
        }

        my ($ip, $time, $request, $code, $compressed_bytes, $referrer, $user_agent, $coeff) =
           ($+{ip}, $+{time}, $+{request}, $+{code}, $+{compressed_bytes}, $+{referrer}, $+{user_agent}, $+{coeff});
           
        $time =~ s/:\d{2} / /;

        for ('total', $ip) {
            ++$log{$_}{count};
            if (!exists $log{$_}{dates}{$time}) {
                $log{$_}{dates}{$time} = 1;
                ++$log{$_}{count_per_minute};
            }
            data_by_codes ($_, $code, $compressed_bytes, $coeff);
        }
    }
    close $fd;
    return $result;
}

sub report {
    my $result = shift;
    my @codes = sort {$a <=> $b} keys $log{total}{compressed_data_by_code};
    my $header = join $separator, qw/IP count avg data/, @codes;
    my @output = ($header);

    my @top_10 = (sort {$log{$b}{count} <=> $log{$a}{count}} keys %log)[0..10];
    for (@top_10) {
        my $current_ip = $log{$_};
        $current_ip->{avg_time} = avg_time ($current_ip->{count}, $current_ip->{count_per_minute});
        my $rounded_data_200 = int (($current_ip->{uncompressed_data_200} // 0) / 1024);
        my $rounded_data_codes = join $separator, map {int(($current_ip->{compressed_data_by_code}{$_} // 0) / 1024) } @codes;
        my $data_line = join $separator, ($_, $current_ip->{count}, $current_ip->{avg_time}, $rounded_data_200, $rounded_data_codes);
        push @output, $data_line;
    }
    print "$_\n" for @output;
}
