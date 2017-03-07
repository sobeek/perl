#! usr/bin/perl -l
use DDP;
use Date::Parse;
use strict;
use warnings;

my $x="a";
#my $y=5.45;

#print ~$x;
#print ~$y;

print ~~$x;
print !!$x;
print 1+$x;
#print "\$y is a string\n" if ($y & ~$y);
