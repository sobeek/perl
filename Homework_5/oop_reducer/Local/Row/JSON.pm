#! usr/bin/perl
package Local::Row::JSON;

use strict;
use warnings;
use JSON::XS;

sub new {
    my $self = undef;
    my $valid = is_valid($_[-1]);
    if ($valid) {
        my $invocant = shift;
        my $class = ref($invocant) || $invocant;
        $self = $valid;          # Оставшиеся аргументы становятся атрибутами
        bless($self, $class);       # «Благословление» в объекты
        #return $self;
    }
    return $self;
}

sub is_valid {
    my $str = shift;
    return {$1 => $2} if $str =~ /{"(\w+)":\s(\d+(?:\.\d+)*)}/;
    undef;
}

sub get {
    my ($obj, $name, $default) = @_;
    return $obj->{$name} // $default;
}

1;
