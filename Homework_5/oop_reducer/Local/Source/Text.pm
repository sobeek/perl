#! usr/bin/perl
use strict;
use warnings;
use Local::Source;

package Local::Source::Text;

our $i = 0;

sub new {
    my $invocant = shift;
    my $class = ref($invocant) || $invocant;
    my $self = { @_ };          # Оставшиеся аргументы становятся атрибутами
    bless($self, $class);       # «Благословление» в объекты
    return $self;
}

sub next {
    my $obj = shift;
    #print $obj;
    my $text = $obj->{text};
    my $delimiter = $obj->{delimiter};
    my $splitted = text_to_array ($text, $delimiter);
    #print $i;
    return Local::Source::get_next($splitted, $i++);
}

sub text_to_array {
    my $text = shift;
    my $delimiter = shift || "\n";
    #print $delimiter;
    return [split $delimiter, $text];
}

1;
