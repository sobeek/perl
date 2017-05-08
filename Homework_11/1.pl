#!usr/bin/perl -l

use strict;
use warnings;
use ExtUtils::testlib;
use Local::Stats;
use DDP;

#settings: avg => 1, sum => 5, max => 2

my $list = ["s", "w", "l"];
my $x = sub {print @$list};
#Stats::new($x);

p Stats::add("abc", {a => 1, b => 2});
