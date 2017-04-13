package Baz;
#use diagnostics;
use strict;
use warnings;

use Foo qw/:all/;

warn "E: ". E;
warn "PI: ". Foo::PI();

1;
