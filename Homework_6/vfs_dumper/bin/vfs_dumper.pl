#!/usr/bin/env perl -l
use utf8;
use strict;
use warnings;
use 5.010;
use JSON::XS;
use FindBin;
use lib "$FindBin::Bin/../lib/";
use VFS;

our $VERSION = 1.0;

binmode STDOUT, ":utf8";

unless (@ARGV == 1) {
	warn "$0 <file>\n";
}
#print @ARGV;
my $buf;
{ local $/ = undef; $buf = <>; }
my $fh;
#print @ARGV;
#open $fh, $ARGV[0] or die;

# Вот досада, JSON получается трудночитаемым, совсем не как в задании.
print JSON::XS::encode_json(VFS::parse($buf));
#print JSON::XS::encode_json(VFS::parse($fh));
