#! usr/bin/perl
use strict;
use warnings;

package Local::Reducer;

=head
sub new {
    my $invocant = shift;
    my $class = ref($invocant) || $invocant;
    my $self = { @_ };          # Оставшиеся аргументы становятся атрибутами
    bless($self, $class);       # «Благословление» в объекты
    return $self;
}
=cut

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
