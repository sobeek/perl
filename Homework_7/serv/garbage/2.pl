use AnyEvent;
use AnyEvent::Socket;

sub finger($$) {
   my ($user, $host) = @_;

   # use a condvar to return results
   my $cv = AnyEvent->condvar;

   # first, connect to the host
   tcp_connect $host, "finger", sub {
      # the callback receives the socket handle - or nothing
      my ($fh) = @_
         or return $cv->send;

      # now write the username
      syswrite $fh, "$user\015\012";

      my $response;

      # register a read watcher
      my $read_watcher; $read_watcher = AnyEvent->io (
         fh   => $fh,
         poll => "r",
         cb   => sub {
            my $len = sysread $fh, $response, 1024, length $response;

            if ($len <= 0) {
               # we are done, or an error occured, lets ignore the latter
               undef $read_watcher; # no longer interested
               $cv->send ($response); # send results
            }
         },
      );
   };

   # pass $cv to the caller
   $cv
}

my $f1 = finger "kuriyama", "freebsd.org";
#my $f2 = finger "icculus?listarchives=1", "icculus.org";
my $f3 = finger "mikachu", "icculus.org";

print "kuriyama's gpg key\n"    , $f1->recv, "\n";
#print "icculus' plan archive\n" , $f2->recv, "\n";
print "mikachu's plan zomgn\n"  , $f3->recv, "\n";
