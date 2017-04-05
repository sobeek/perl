#!usr/bin/perl -l
use AnyEvent;
{
    my $var = rand();
    my $sub = sub {
        print $var;
    }
}

sub decorator {
    my $decor = shift;
    return sub {
        return $decor."@_".$decor;
    }
}
my $dq = decorator "'";
print $dq;
my $dd = decorator '"';
print $dd;
my $ds = decorator '/';
print $dq->('test'); # 'test'
print $dd->('test'); # "test"
print $ds->('test'); # /test/

my $cv = AE::cv; $cv->begin;
my @array = 1..10;
my $i = 0;
my $next; $next = sub {
my $cur = $i++;
return if $cur > $#array;
print "Process $array[$cur]";
$cv->begin;
async sub {
print "Processed $array[$cur]";
$next->();
$cv->end;
};
}; $next->() for 1..3;
$cv->end; $cv->recv;
