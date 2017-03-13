#! usr/bin/perl -l
use DDP;
use Date::Parse;
use strict;
use warnings;

my @a = 1..4;
for (@a) {
    $_ = 1;
}
print @a;
