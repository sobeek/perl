#! usr/bin/perl
use strict;
use warnings;

package Local::Reducer;

sub new {
    my $invocant = shift;
    my $class = ref($invocant) || $invocant;
    my $self = { @_ };          # Оставшиеся аргументы становятся атрибутами
    bless($self, $class);       # «Благословление» в объекты
    return $self;
}

sub get_name {
    my $obj = shift;
    print $obj;
    return $obj->{name};
}

1;
