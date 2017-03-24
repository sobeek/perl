#! usr/bin/perl -l
use strict;
use warnings;
use JSON::XS;# qw/decode_json/;
use DDP;

my $x = '{"price": 0}';
p $x;
$x =~ s/:/=>/;
p $x;
my %a = "$x";
p %a;
