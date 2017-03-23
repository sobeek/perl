#! usr/bin/perl
use strict;
use warnings;
use Local::Source;

package Local::Source::Text;
#our @ISA = ("Local::Source");
#our $i = 0;

sub new {
    my $invocant = shift;
    my $class = ref($invocant) || $invocant;
    my $self = { @_, counter => 0 };          # Оставшиеся аргументы становятся атрибутами
    bless($self, $class);       # «Благословление» в объекты
    return $self;
}

sub next {
    #warn "NEXT IN TEXT...";
    my $obj = shift;
    my $text = $obj->{text};
    my $delimiter = $obj->{delimiter} // "\n";
    #print $delimiter;
    my $splitted = text_to_array ($text, $delimiter);
    my $i = $obj->{counter};
    my $result = Local::Source::get_next ($splitted, $i);
    if (defined $result) {
        $obj->{counter}++;
        return $result
    }
    else {
        return undef
    }
}

sub text_to_array {
    my ($text, $delimiter) = @_;
    #my $delimiter = shift || "\n";
    #print $delimiter;
    return [split $delimiter, $text];
}

1;
