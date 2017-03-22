#! usr/bin/env/perl

use strict;
use warnings;
#use DDP;
use IO::Uncompress::Bunzip2 qw(bunzip2 $Bunzip2Error);

$/ = "\n";
#$, = "\t";
my $separator = "\t";

#system("$^X bin/analyze.pl access.log.bz2 >output.tmp 2>stderr.tmp");
#my $f = 'output.tmp';
#open(my $f, '<', 'output.tmp');
#$output_fh->close();

#my $input = new IO::File "<access.log.bz2" or die "Cannot open 'access.log.bz2': $!\n";
my $f = "access.log.bz2";
my $tmp;
bunzip2 $f => \$tmp;
#print $tmp;
my @tmp = split $/, $tmp;
#my $f = './access.log';
#open F, $f or die "$!";
my %log = ();

my @patt = qw /
            ^(.*?)\s
            \[(.*?)\]\s
            "(.*?)"\s
            (\d+)\s
            (\d+)\s
            "(.*?)"\s
            "(.*?)"\s
            "(\d+(?:\.\d+)*|-)"$
            /;

sub data_by_codes {
    my ($ip, $code, $compressed_bytes, $coeff) = @_;
    #my $compressed_kilobytes = $compressed_bytes / 1024;
    #$log{$ip}{compressed_data_by_code}{$code} += $compressed_kilobytes;

    #rounding and transforming to KBytes is performing at output

    $log{$ip}{compressed_data_by_code}{$code} += $compressed_bytes;
    if (200 == $code) {
        #$coeff = 1 if $coeff !~ /\d+(\.\d+)*/;
        $coeff = 1 if $coeff =~ /^-$/; #very probably it is ok
        #$log{$ip}{uncompressed_data_200} += $compressed_kilobytes * $coeff;
        $log{$ip}{uncompressed_data_200} += $compressed_bytes * $coeff;
    }
}

sub avg_time {
    my ($count, $count_per_minute) = @_;
    return sprintf ("%.2f", $count / $count_per_minute)
}

sub time_formatter {
    $_[0] =~ s/:\d{2} / /; #cut off seconds
}


#while ($input->getline()) {
for (@tmp) {
    #print;
    my @data = ();
    my $invalid_line = 0;
    chomp;

    my $buf = $_;
    for (@patt) {
        $buf =~ /$_/;
        #print $-[0]." ".$+[0];
        if ($-[0]) {
            #print $., "@data";
            #print "INVALID!!";
            $invalid_line = 1;
            last
        }
        #my $x = $1;
        push @data, $1;
        $buf = substr $buf, $+[0];
    }

    if ($invalid_line || $buf) {
        ++$log{total}{count};
        next;
    }

    my ($ip, $time, $request, $code, $compressed_bytes, $referrer, $user_agent, $coeff) = @data;
    time_formatter ($time);

    for ('total', $ip) {
        ++$log{$_}{count};
        if (!exists $log{$_}{dates}{$time}) {
            $log{$_}{dates}{$time} = 1;
            ++$log{$_}{count_per_minute};
        }
        data_by_codes ($_, $code, $compressed_bytes, $coeff);
    }
}
#close $input;

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
    #print ($_, $current_ip->{count}, $current_ip->{avg_time}, $rounded_data_200, $rounded_data_codes);
    #print $x;
    push @output, $data_line;
    #print $_;
    #p $log{$_};
    #<>;
}

push @output, "";

print join $/, @output;
#print "\n"
