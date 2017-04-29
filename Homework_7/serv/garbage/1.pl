#!usr/bin/perl -l
use strict;
use warnings;

use AnyEvent;

$| = 1; print "enter your name> ";

my $name_ready = AnyEvent->condvar;

my $wait_for_input = AnyEvent->io (
    fh => \*STDIN, poll => "r",
    cb => sub { $name_ready->send (scalar <STDIN>) }
);

my @x = map {$_ ** 2} 1..5;
print "@x";
# now wait and fetch the name
my @name = $name_ready->recv;

#undef $wait_for_input; # watcher no longer needed

print "your name is @name";
