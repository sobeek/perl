#!/usr/bin/env perl -l

use strict;
use warnings;
use feature "switch";
use DDP;

sub dumper;

sub dumper {
    my $what = shift;
    my $depth = shift || 0;
    if (my $ref = ref $what) {
        #print $ref;
        given ($ref) {
            when ('ARRAY') {
                my $array = [];
                push @$array, dumper($_, $depth + 1) for @$what;
                return $array;
            }
            when ('HASH') {
                my $hash = {};
                while (my ($k, $v) = each %$what) {
                    #print " "x$depth, "$k:";
                    $hash->{$k} = dumper($v, $depth + 1);
                }
                #p $hash;
                #<>;
                return $hash;
            }
            default {
                die "unsupported: $ref"; }
        }
    }
    else {
        #print " "x$depth, $what;
        return $what;
    }
}

my @pic = (
[ { r=>123, g=>127, b=>27 } ],
[ { r=>99, g=>255, b=>127 } ]);
my @gray = map { # $_ is a row
[
map { # $_ is a cell
int(($_->{r}+$_->{g}+$_->{b})/3)
} @$_
];
} @pic;

p @gray;
print "";
my $x = dumper \@gray;
p @$x;
