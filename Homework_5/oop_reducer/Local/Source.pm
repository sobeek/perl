#! usr/bin/perl
use strict;
use warnings;

package Local::Source;

#our $i = 0;

sub get_next {
    my ($array, $i) = @_;
    my $len_array = @$array;
    if ($i < $len_array) {
        return $array->[$i];
    }
    elsif ($i == $len_array) {
        $i = 0;
        print "Source is ended";
        return undef;
    }
    else {
        print "Smth going wrong...\n"
    }
}

sub get_next_from_file {
    my $filehandle = shift;
    #open F, $filename or die $!;
    my $read = <$filehandle>;
    #chomp $read;
    #print $.;
    if ($read) {
        chomp $read;
        return $read
    }
}

1;
