#!/usr/bin/env perl -l

use strict;
use warnings;
use feature "switch";
use DDP;
=head
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
=cut

sub dumper; sub dumper {
my $what = shift; my $depth = shift || 0;
if (my $ref = ref $what) {
if ($ref eq 'ARRAY') {
print " "x$depth,
"-";
dumper($_,$depth+1) for @$what;
}
elsif ($ref eq 'HASH') {
while (my ($k,$v) = each %$what) {
print " "x$depth,
"$k:";
dumper($v,$depth+1);
}
}
else { die "unsupported: $ref"; }
}
else {
print " "x$depth,$what;
}
}

my $CYCLE_ARRAY = [ 1, 2, 3 ];


$CYCLE_ARRAY->[4] = $CYCLE_ARRAY;
$CYCLE_ARRAY->[5] = $CYCLE_ARRAY;

print $CYCLE_ARRAY;
$CYCLE_ARRAY =~ /(0x\w+)/;
my $address = $1;
print $address;
my $from = shift || 0;
#$from =~ /(0x\w+)/;
#my $address_from = $1;

if ($from eq $address) {
    print "CYCLIC!";
    <>;
    #return $what;
}

__DATA__
=head1
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
=cut
#p @gray;
print "";
my $x = dumper $CYCLE_ARRAY;
p @$x;
