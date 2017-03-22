#! usr/bin/perl
use strict;
use warnings;

package Local::Row;

=head
sub new {
    my $invocant = shift;
    my $class = ref($invocant) || $invocant;
    my $self = { @_ };          # Оставшиеся аргументы становятся атрибутами
    bless($self, $class);       # «Благословление» в объекты
    return $self;
}

1;
=cut
