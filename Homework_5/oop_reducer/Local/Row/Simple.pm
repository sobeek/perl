#! usr/bin/perl
use strict;
use warnings;

package Local::Row::Simple;

sub new {
    #print "@_";
    my $self = undef;
    #print "VALID?";
    #p $valid;
    my $x = qr /\w+:\d+(?:\.\d+)*/;
    if ($_[-1] =~ /^$x(,$x)*$/m) {
        #warn "MAKING SELF...$_[-1]";
        my $invocant = shift;
        my $class = ref($invocant) || $invocant;
        $self = { @_ };          # Оставшиеся аргументы становятся атрибутами
        bless($self, $class);       # «Благословление» в объекты
    }
    #else {
    #    warn "BAD... $_[-1]"
    #}
    return $self;
}

sub get {
    my ($obj, $name, $default) = @_;
    #print $obj;
    return undef unless $obj->{str};
    my %splitted = split /[:,]/, $obj->{str};
    #print "\%SPLITTED: ", %splitted;
    return $splitted{$name} || $default;
}


1;
