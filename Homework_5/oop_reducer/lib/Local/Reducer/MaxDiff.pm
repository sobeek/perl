#! usr/bin/perl
use strict;
use warnings;

package Local::Reducer::MaxDiff;

our @ISA = "Local::Reducer";

sub new {
    my $invocant = shift;
    my $class = ref($invocant) || $invocant;
    my $self = { @_ };          # Оставшиеся аргументы становятся атрибутами
    bless($self, $class);       # «Благословление» в объекты
    return $self;
}

sub reducer {
    my ($obj, $n) = @_;
    my $i = 0;
    my $source = $obj->{source};
    my $top = $obj->{top};
    my $bottom = $obj->{bottom};
    my $class = $obj->{row_class};
    my $max = $obj->{initial_value};
    my $diff;
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
        next if !defined $obj_to_parse;
        #print values %$obj_to_parse;
        $diff = $obj_to_parse->get($top, 0) - $obj_to_parse->get($bottom, 0);
        #<>;
        #print "DIFF: $diff";
        $max = $max > $diff ? $max : $diff;
        $obj->{initial_value} = $max;
    }
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
