#! usr/bin/perl
use strict;
use warnings;
use JSON::XS;# qw/decode_json/;

package Local::Row::JSON;

sub new {
    my $invocant = shift;
    my $class = ref($invocant) || $invocant;
    my $self = { @_ };          # Оставшиеся аргументы становятся атрибутами
    bless($self, $class);       # «Благословление» в объекты
    return $self;
}

sub get {
    my ($obj, $name, $default) = @_;
    my $str = $obj->{str};
    return undef unless $str;
    #print \$str;
    #my $json = JSON::XS->new->allow_nonref;
    my $decoded_from_json = JSON::XS::decode_json(qq{$str});
    #$str =~ s/[\" \{\}]//g;
    #print "STR: ".$str;
    #my %splitted = split /[:]/, $str;
    #print "\%SPLITTED: ", %splitted;
    #return $splitted{$name} || $default;
    return $decoded_from_json->{$name} || $default;
}

1;
