#!usr/bin/perl -l

use strict;
use warnings;
use 5.010;
#use DDP;
use JSON::XS;
use Socket ':all';
#use AnyEvent;

$|++;
socket my $s, AF_INET, SOCK_STREAM, IPPROTO_TCP;
my $host = 'localhost'; my $port = 1234;
my $addr = gethostbyname $host;
my $sa = sockaddr_in($port, $addr);
connect($s, $sa);
#print $s;
binmode ($s);
while (1) {
    print "Enter:";
    my $msg = <>;
    #print $send;
    syswrite $s, $msg or die "send: $!";
    my $buf = "";
    my $r = 1023;
    my $total_buf;
    while (1023 - $r == 0) {
        $r = sysread $s, $buf, 1023;
        $total_buf .= $buf;
    }
    #print 1;
    #$buf = join '', <$s>;
    if (defined $buf) {
        parse_answer($msg, $total_buf);
        #print "GOT: ".$buf;
    }
    else {
        die "recv failed: $!"
    }
    last if $msg eq "FIN\n";
}

sub parse_answer {
    my ($message, $response) = @_;
    chomp $message;
    chomp $response;
    given ($message) {
        when ("HEAD") {
            #print $response;
            my ($ok, $json) = split /\n/, $response;
            print $ok;
            my $headers;
            eval {
                $headers = decode_json $json;
            #print "\n-----------------------\n";
                print "$_: ".$headers->{$_} for keys $headers;
            }
        }
        default {
            print $response;
        }
    }
}
