#! usr/bin/perl
use strict;
use warnings;

package Local::Reducer;

sub reduce_n {
    my ($obj, $n) = @_;
    return $obj->reducer ($n);
}

sub reduce_all {
    my ($obj, $n) = @_;
    return $obj->reducer (-1);
}

sub reduced {
    my $obj = shift;
    return $obj->{initial_value};
}

1;
