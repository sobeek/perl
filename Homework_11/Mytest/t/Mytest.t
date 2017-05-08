# Before 'make install' is performed this script should be runnable with
# 'make test'. After 'make install' it should work as 'perl Mytest.t'

#########################

# change 'tests => 1' to 'tests => last_test_to_print';

use strict;
use warnings;

use Test::More tests => 13;
BEGIN { use_ok('Mytest') };

#########################

# Insert your test code below, the Test::More module is use()ed here so read
# its man page ( perldoc Test::More ) for help writing this test script.

is(&Mytest::is_even(0), 1);
is(&Mytest::is_even(1), 0);
is(&Mytest::is_even(2), 1);
my $i;
$i = -1.5; &Mytest::round($i); is( $i, -2.0 );
$i = -1.1; &Mytest::round($i); is( $i, -1.0 );
$i = 0.0; &Mytest::round($i);  is( $i,  0.0 );
$i = 0.5; &Mytest::round($i);  is( $i,  1.0 );
$i = 1.2; &Mytest::round($i);  is( $i,  1.0 );

my @a = &Mytest::statfs("/blech");
ok( scalar(@a) == 1 && $a[0] == 2 );
@a = &Mytest::statfs("/");
is( scalar(@a), 7 );

my $results = Mytest::multi_statfs([ '/', '/blech' ]);
ok( ref $results->[0] );
ok( ! ref $results->[1] );
