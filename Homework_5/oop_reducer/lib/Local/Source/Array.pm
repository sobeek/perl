#! usr/bin/perl

package Local::Source::Array;

use strict;
use warnings;
use parent 'Local::Source';

sub new {
    my $invocant = shift;
    my $class = ref($invocant) || $invocant;
    my $self = { @_, counter => 0 };          # Оставшиеся аргументы становятся атрибутами
    bless($self, $class);       # «Благословление» в объекты
    return $self;
}

sub next {
    my $obj = shift;
    my $arr = $obj->{array};
    my $i = $obj->{counter};
    my $result = get_next ($arr, $i);
    #my $result = Local::Source::get_next ($arr, $i);
    if (defined $result) {
        $obj->{counter}++;
        return $result
    }
    else {
        return undef;
    }
}

1;
