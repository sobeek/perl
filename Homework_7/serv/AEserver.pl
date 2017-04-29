#!usr/bin/perl

use strict;
use warnings;
use AnyEvent::Socket;
use 5.010;
#use DDP;
use LWP::Simple;
use JSON::XS;
use Encode qw/encode/;

my $host = "0.0.0.0";
my $port = 1234;

tcp_server $host, $port, sub {
    my $fh = shift;
    #print "smb connected!\n";
    my $url;
    my $response = '';
    my $read_watcher; $read_watcher = AnyEvent->io (
        fh   => $fh,
        poll => "r",
        cb   => sub {
            print "smb sends us a message!\n";
            my $len = sysread $fh, $response, 1024, length $response;
            chomp $response;
            if ($len <= 0) {
               #AE::cv->send ($response); # send results
               #syswrite $fh, "BYE";
               undef $read_watcher;
               #!!! magic line!
            }
            given ($response) {
                when ("FIN") {
                    #BYE
                    syswrite $fh, "OK\n";
                }
                when (/^URL\s/) {
                    #print $`;
                    $url = substr $response, $+[0];
                    print "URL: $url\n";
                    syswrite $fh, "OK\n";
                }
                when ("HEAD") {
                    my $headers = get_head ($url);
                    syswrite $fh, "$headers\n";
                }
                when ("GET") {
                    my $body = get_body ($url);
                    syswrite $fh, "$body\n";
                }
                default {
                    syswrite $fh, "Not OK: unknown command\n";
                }
            }
            #AE::cv->send ($response);
            $response = '';
        },
    );
};

sub get_head {
    my $url = shift;
    return "No URL defined" if !$url;
    print "URL (get_head): ".$url;
    #$url = 'https://mail.ru';
    my @content;
    eval {
        @content = head($url);
    } or do {
        return "Not OK: invalid URL";
    };
    my %headers = ();
    @headers{'content type', 'document length', 'modified time', 'expires', 'server'} = @content;
    #p %headers;
    my $json_headers = encode_json \%headers;
    return "OK\n$json_headers";
}

sub get_body {
    my $url = shift;
    return "No URL defined" if !$url;
    print "URL (get_head): ".$url;
    my $content;
    eval {
        $content = encode ('utf8', get($url));
    } or do {
        return "Not OK: invalid URL!";
    };
    return "OK\n$content";
}

AE::cv->recv;
