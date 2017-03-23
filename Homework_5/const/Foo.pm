#! usr/bin/perl
package Foo;

use strict;
use warnings;
use myconst math => {
                PI => 3.14,
                E => 2.7,
            },
            ZERO => 0,
            EMPTY_STRING => '',
            ONE => 1,
            TWO => 2;

$, = ',';
#warn "EXPORT_OK: ", @Foo::EXPORT_OK;
warn "E: ", E;
#print ZERO();
1;
