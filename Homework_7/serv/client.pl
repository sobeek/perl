#!usr/bin/perl -l

use strict;
use Socket ':all';
$|++;
socket my $s, AF_INET, SOCK_STREAM, IPPROTO_TCP;
my $host = 'localhost'; my $port = 8888;
my $addr = gethostbyname $host;
my $sa = sockaddr_in($port, $addr);
connect($s, $sa);
#print $s;
binmode ($s);

#send $s, "HELLO!!\n\n", 0 or die "send: $!";
while (1) {
    print "Enter:";
    my $send = <>;
    #print $send;
    send $s, $send, 0 or die "send: $!";
    my $r = recv $s, my $buf, 1024, 0;
    if (defined $r) {
        #warn;
        last unless length $buf;
        print "GOT: ".$buf;
    }
    else {
        die "recv failed: $!"
    }
}
