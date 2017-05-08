#!usr/bin/perl -l

use strict;
use warnings;
use ExtUtils::testlib;
use Stats;
use DDP;

#settings: avg => 1, sum => 5, max => 2

my $list = ["avg", "cnt", "sum"];
sub x {
    print 199;
    #return @$list
};
my $x = \&x;
Stats::new($x);

my $h1 = Stats::add("abc", {avg => 1, cnt => 2, sum => 4});
p $h1;
p Stats::add("bbc", {avg => 10, cnt => 20, sum => 40});
