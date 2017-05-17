#!usr/bin/perl -l

use strict;
use warnings;
use ExtUtils::testlib;
use Stats;
use DDP;

#settings: avg => 1, sum => 5, max => 2

my @list = ("max", "cnt", "sum", "min", "avg");
sub x {
    print 199;
    p @list;
    return @list;
    #return @$list
};
my $x = \&x;
my $metric = Stats::new($x);
#p $metric;

p Stats::add($metric, "abc", 90);
p Stats::add($metric, "abc", 100);
#p $h1;
#p Stats::add("bbc", {avg => 10, cnt => 20, sum => 40});
