#!usr/bin/perl -l

use strict;
use warnings;
use ExtUtils::testlib;
use Stats;
use DDP;

#settings: avg => 1, sum => 5, max => 2

my @list = ("avg", "cnt", "sum", "min", "max");
sub x {
    #print 199;
    #print @list;
    return @list;
    #return @$list
};
my $x = \&x;
my $metric = Stats::new($x);
#p $metric;

#print "we've got";
Stats::add($metric, "abc", 90);

@list = ("cnt");
#my $metric_2 = Stats::new($x);
Stats::add($metric, "def", 100);
Stats::add($metric, "def", 200);
Stats::add($metric, "abc", 100);

p Stats::stat($metric);

#p Stats::add($metric_2, "def", 22);
