#! usr/bin/perl -l
#####################################################
package nnn;

use DDP;
use strict;
use warnings;
#use Exporter qw/import/;

BEGIN {
    push @INC, "./lib";
    #print "@INC";
}

use myconst phys => {g => 9.81 , PI => 3.1416 }, STRING => 'A';
BEGIN { $INC{"nnn.pm"} = "1"; } # fuck you you fucking fuck
#####################################################
#####################################################
package aaa;
use DDP;
use myconst math => {PI => 3.14, E => 2.7 }, STRING => 'some string';
BEGIN { $INC{"aaa.pm"} = "1"; } # fuck you you fucking fuck
p @aaa::EXPORT_OK;

#####################################################

#####################################################
package bbb1;
use nnn qw/PI STRING/;

warn "bbb1 PI: ". bbb1::PI();

package bbb2;
use aaa qw/PI STRING/;

warn "bbb2 PI: ". bbb2::PI();

package main;

warn "bbb1 PI: ". nnn::PI();

=head
use myconst math => {
                PI => 3.14,
                E => 2.7,
            },
            ZERO => 0,
            EMPTY_STRING => '',
            ONE => 1,
            TWO => '';



math => {
                PI => {},
                E => 2.7,
            },
            ZERO => 0,
            EMPTY_STRING => '',
            ONE => 1,

#<>;

package Bar;

use Foo qw/:math ZERO/;

warn "Foo: ".Foo::PI();
warn "ZERO: ". ZERO;
TWO => '';
=cut
1;
