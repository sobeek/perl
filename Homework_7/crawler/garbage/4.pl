#!usr/bin/perl -l

use AnyEvent;

sub async {
    my $cb = pop;
    my $w;$w = AE::timer rand(0.1), 0, sub {
        undef $w;
        $cb->();
    };
    return;
}

my $cv = AE::cv; $cv->begin;
my @array = 1..10;
my $i = 0;
my $next;
$next = sub {
    my $cur = $i++;
    return if $cur > $#array;
    print "Process $array[$cur]";
    $cv->begin;
    async sub {
        print "Processed $array[$cur]";
        $next->();
        $cv->end;
    };
};
$next->() for 1..3;
#$cv->send;
$cv->end;
$cv->recv;
