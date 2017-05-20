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
    print @list;
    return @list;
    #return @$list
};
my $x = \&x;
my $metric_1 = Stats::new($x);
#p $metric;

#print "we've got";
p Stats::add($metric_1, "abc", 90);

@list = ();
#my $metric_2 = Stats::new($x);
Stats::add($metric_1, "def", 100);
Stats::add($metric_1, "def", 200);
Stats::add($metric_1, "abc", 100);

p Stats::stat($metric_1);

#p Stats::add($metric_2, "def", 22);
