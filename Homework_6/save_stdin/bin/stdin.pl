#!/usr/bin/perl
use strict;
use warnings;
use Getopt::Long;

my $file = '';
GetOptions ('file=s' => \$file);
open my $fh, '>', $file or die $!;

my $interrupt = 0;
my $size = 0;
my $lines = 0;
$SIG{'INT'} = \&interrupt;

sub interrupt {
    ++$interrupt;
    print STDERR "Double Ctrl+C for exit" if 1 == $interrupt;
    if (2 == $interrupt) {
        close $fh;
        print "$size $lines ". $size / $lines."\n";
        exit(0)
    }
}

sub stats {
    my ($read, $buf) = @_;
    my @data = split $/, $buf;
    $size += ($read - @data);
    $lines += @data;
}

sub run {
    print "Get ready\n";

    while (1) {
        my $read = sysread (STDIN, my $buf, 1024);
        if (!$buf) {
            $interrupt = 1;
            interrupt();
        }
        stats ($read, $buf);
        $interrupt = 0 if $interrupt;
        print $fh $buf;
    }
}

run;
