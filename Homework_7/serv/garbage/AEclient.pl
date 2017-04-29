use AnyEvent::Socket;

my $cv = AnyEvent->condvar;

tcp_connect localhost => 1234, sub {
    if (my $fh = shift) {
        #print ($fh);
        syswrite $fh, "X\n";
        #print <$fh>;
        #ping($fh);
        print "Enter message:\n";
        my $msg = <STDIN>;
        my $response;
        my $read_watcher; $read_watcher = AnyEvent->io (
            fh   => $fh,
            poll => "r",
            cb   => sub {
                print "smb sends us a message!\n";
                my $len = sysread $fh, $response, 1024, length $response;
                print "LEN = $len\n";
                print $response;
                if ($len <= 0) {
                   # we are done, or an error occured, lets ignore the latter
                   AE::cv->send ($response);
                   undef $read_watcher; # no longer interested
                    # send results
                   syswrite $fh, "BYE"
                }
                AE::cv->send ($response);
                undef $response;
            },
        );
        syswrite $fh, "";
        print <$fh>;
        #$cv->send;
        #last
        #"GET / HTTP/1.0\n\n";
    }
    else {
        warn "Connect failed: $!";
    }
};

sub ping {
    my ($fh) = @_;
    while (1) {
        print "Enter message:\n";
        my $msg = <STDIN>;
        return if $msg eq "FIN\n";
        #chomp $msg;
        print "Sending $msg";
        syswrite $fh, $msg;

    }
}

sub get_answer {

}

$cv->recv;
#exit
