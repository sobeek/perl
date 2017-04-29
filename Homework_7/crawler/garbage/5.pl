#! usr/bin/perl -l
use Web::Query;
use DDP;
use LWP::Simple;
use URI;

my $url = q{https://github.com/Nikolo/Technosfera-perl/tree/anosov-crawler};
my $base = URI->new($url);
my $content = get ($url);

my $q = wq( $content );
#my $wq = wq( '<div><p>hello</p><p>there</p></div> );
my $f;
$f = sub {
    my ($i, $elem) = @_;
    #print $i, $elem->attr('href');
    my $uri = URI->new_abs($elem->attr('href'), $base);
    #my $found_url = ;
    if ($uri !~ m|#| && $uri =~ /^$url/) {
        print $uri;
    }
};

my $x = $q->find( 'a' )->each($f);
=h
sub {
    my ($i, $elem) = @_;
    #print $i, $elem->attr('href');
    my $uri = URI->new_abs($elem->attr('href'), $base);
    #my $found_url = ;
    if ($uri !~ m|#| && $uri =~ /^$url/) {
        print $uri;
    }
}
=cut
#);



#p $x

__DATA__
my @a = 1..5;
my $i = 0;
for (@a) {
    push @a, $_ ** 2;
    print $_;
    <>;
    return if $i > $#a;
    ++$i;
}
