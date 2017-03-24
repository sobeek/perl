package Baz;

use strict;
use warnings;

use Foo qw/:math/;

warn "E: ". Foo::E;     # ''
warn "PI: ". PI;

1;
