#! usr/bin/perl
use strict;
use warnings;

package Bar;

use Foo qw/ZERO/;
#use Exporter;

print "ZERO: ".ZERO;             # 0
#print PI;               # 3.14
1;
