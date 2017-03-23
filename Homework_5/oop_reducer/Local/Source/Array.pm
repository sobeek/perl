#! usr/bin/perl
use strict;
use warnings;
use Local::Source;

package Local::Source::Array;
#our @ISA = ("Local::Source");

#my $i = 0;

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
    #my $result = Local::Source::get_next ($arr, $i++);
    my $result = Local::Source::get_next ($arr, $i);
    if (defined $result) {
        $obj->{counter}++;
        return $result
    }
    else {
        return undef;
    }
}

1;
