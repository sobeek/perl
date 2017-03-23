#! usr/bin/perl
use strict;
use warnings;

package Local::Source::Filehandler;

#our $i = 0;

sub new {
    my $invocant = shift;
    my $class = ref($invocant) || $invocant;
    my $self = { @_ };          # Оставшиеся аргументы становятся атрибутами
    bless($self, $class);       # «Благословление» в объекты
    return $self;
}

sub next {
    my $obj = shift;
    my $fh = $obj->{filehandle};
    return Local::Source::get_next_from_file ($fh);
}

1;
