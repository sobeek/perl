#!usr/bin/perl -l

use strict;
use warnings;
use ExtUtils::testlib;
use Stats;
use DDP;

my @list = ("avg", "cnt", "sum", "min", "max");
sub x {
    return @list;
};
my $x = \&x;
my $metric = Stats::new($x);

Stats::add($metric, "abc", 90);

@list = ("cnt");
Stats::add($metric, "def", 100);
Stats::add($metric, "def", 200);
Stats::add($metric, "abc", 100);

p Stats::stat($metric);
