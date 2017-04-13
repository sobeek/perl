#! usr/bin/perl
use strict;
use warnings;

package Bar;

use Foo qw/:math ZERO/;

warn "Foo: ".Foo::PI();

warn "ZERO: ". ZERO;             # 0
#print PI;               # 3.14
1;
