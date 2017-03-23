#! usr/bin/perl
use strict;
use warnings;

package Bar;

use Foo qw/:all/;
#use Exporter;

warn "Foo".Foo::ZERO();

warn "ZERO: ". Foo::ZERO;             # 0
#print PI;               # 3.14
1;
