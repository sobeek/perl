#!usr/bin/perl -l

use strict;
use warnings;
use POSIX ":sys_wait_h";

my @a = 1..5;
my %pids = ();
my $threads = 3;
$| = 1;
my $forks = 0;

$SIG{'CHLD'} = sub {
    while ( (my $pid = waitpid(-1, WNOHANG)) > 0 ) {
        #my $pid = wait();
        print "PID IN CHLD: $pid";
        #print "hi";
        my $reader = $pids{$pid};
        #select $reader;
        my $line = <$reader>;
        chomp $line;
        print "READ: $line"
    }
};

for (@a) {
    my $index = $_;
    my $parent;
    my $child;
    pipe $parent, $child or die;

    my $pid = fork();
    die "fork() failed: $!" if !defined $pid;
    if ($pid) {
        ++$forks;
        close $child;
        $pids{$pid} = $parent;
        if ($forks == $threads) {
            #print "FORKS: $forks";
            sleep(100_000);
            --$forks
        }
    }

    else {
        close $parent;
        print $child $index ** 2;
        #print $index ** 2;
        #sleep(1);
        exit;
    }
    #print "X";
    #sleep(1)
}

wait();
#print "DONE";
#<>;
