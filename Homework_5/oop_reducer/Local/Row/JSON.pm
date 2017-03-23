#! usr/bin/perl
package Local::Row::JSON;

use strict;
use warnings;
use JSON::XS;
use DDP;

sub new {
    #print "@_";
    my $self = undef;
    my $valid = is_valid($_[-1]);
    #print "VALID?";
    #p $valid;
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
    #my ($obj, $name, $default) = @_;
    #my $str = $obj->{str};
    #print "VALIDATING...";
    my $str = shift;
    #my $decoded_from_json = undef;
    #print \$str;
    return {$1 => $2} if $str =~ m({"(\w+)":\s(\d+(?:\.\d+)*)});
    undef;
    #my $json = JSON::XS->new->allow_nonref;
    #eval {
    #    $decoded_from_json = JSON::XS::decode_json(qq{$str});
    #    my $json_type = ref $decoded_from_json;
    #    undef $decoded_from_json if $json_type ne 'HASH';
    #}
    #or do {
    #    warn "BAD";
    #}

    #my $json_type = ref $decoded_from_json;

}

sub get {
    my ($obj, $name, $default) = @_;
    #print "GETTING...";
    #print "@_";
    #my $value = $obj->{$name};
    #return undef unless $str;
    #my $decoded_from_json = undef;
    #return $decoded_from_json->{$name} ? $decoded_from_json->{$name} : $default;
    return $obj->{$name} // $default;
}

1;
