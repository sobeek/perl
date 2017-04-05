use AnyEvent::HTTP;

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
        $cv->send;
    };
$cv->recv;
