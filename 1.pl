#! usr/bin/perl -l
use DDP;
use Date::Parse;
use strict;
use warnings;

my $s = "The black cat climbed the green tree";
my $color  = substr $s, 4, 5;      # black
print $color;
print $s;
