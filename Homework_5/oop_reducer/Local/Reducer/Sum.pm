#! usr/bin/perl
use strict;
use warnings;

package Local::Reducer::Sum;

our @ISA = "Local::Reducer";

sub new {
    my $invocant = shift;
    my $class = ref($invocant) || $invocant;
    my $self = { @_ };          # Оставшиеся аргументы становятся атрибутами
    bless($self, $class);       # «Благословление» в объекты
    return $self;
}

sub reducer {
    #print "GENERAL REDUCER";
    my ($obj, $n) = @_;
    #print $n;
    my $i = 0;
    my $source = $obj->{source};
    my $field = $obj->{field};
    my $class = $obj->{row_class};
    while ($i != $n) {
        ++$i;
        #last if
        my $got = $source->next();
        #print "GOT: ".$got if defined $got;
        #<>;
        #print "DEFINED!" if defined $got;
        last if !defined $got;
        #print $got;
        my $obj_to_parse = $class->new(str => $got);
        #print values %$obj_to_parse;
        if (!defined $obj_to_parse) {
            #print "OU";
            next;
        };
        $obj->{initial_value} += $obj_to_parse->get($field, 0);

    }
    #$result = $obj->{reduced};
    #print "REDUCED INNER: ".$obj->{initial_value};
    return $obj->{initial_value};
}

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
