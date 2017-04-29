#!usr/bin/perl

use strict;
use warnings;
use 5.010;
use DDP;
use LWP::Simple;
use JSON::XS;
use Encode qw/encode/;
use AnyEvent::HTTP;
use Web::Query;

my $cv = AnyEvent->condvar;

http_get "https://www.sports.ru/",
    cookie_jar => {},
    headers    => {},
    sub {
        my ($body, $hdr) = @_;

        if ($hdr->{Status} =~ /^2/) {
            print "OK";
        } else {
            print "error, $hdr->{Status} $hdr->{Reason}\n";
        }
        $cv->send ($hdr);
    };

my $res = $cv->recv;
p $res;
