#! usr/bin/perl
package Foo;

use strict;
use warnings;
#use Exporter;
use myconst math => {
                PI => 3.14,
                E => 2.7,
            },
            ZERO => 0,
            EMPTY_STRING => '',
            ONE => 1,
            TWO => 2;

#print @INC;

sub import {
    $" = " ";
    no strict 'refs';
    #use Exporter;
    my $pkg = shift;
    print "@_";

    my $caller = caller;
    print "CALLER: ". $caller;
    #myconst::import(@_, \$caller);
    for (@_) {
        if (/^:/) {
            print;
            my $full_name = "${caller}::$_";
            print $full_name;
            *$full_name = "${pkg}::$_"
        }

    }
    #"${pkg}::$_"
    #*{$caller::$_} = *{$Foo::$_} for @_;
}

print "TWO: ". TWO;
#print ZERO();
1;
