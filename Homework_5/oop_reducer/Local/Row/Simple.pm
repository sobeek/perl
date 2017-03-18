#! usr/bin/perl
use strict;
use warnings;

package Local::Row::Simple;

sub new {
    my $invocant = shift;
    my $class = ref($invocant) || $invocant;
    my $self = { @_ };          # Оставшиеся аргументы становятся атрибутами
    bless($self, $class);       # «Благословление» в объекты
    return $self;
}

sub get {
    my ($obj, $name, $default) = @_;
    print $obj;
    return undef unless $obj->{str};
    my %splitted = split /[:,]/, $obj->{str};
    print "\%SPLITTED: ", %splitted;
    return $splitted{$name} || $default;
}


1;
