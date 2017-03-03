use strict;
use warnings;

=encoding UTF8
=head1 SYNOPSYS
ѕоиск номера первого не нулевого бита.
=head1 run ($x)
‘ункци€ поиска первого не нулевого бита в 32-битном числе (кроме 0).
ѕачатает номер первого не нулевого бита в виде "$num\n"
ѕримеры:
run(1) - печатает "0\n".
run(4) - печатает "2\n"
run(6) - печатает "1\n"
=cut

sub run {
    my ($x) = @_;
    my $num = -1;
    my $rem = 0;

    while (!$rem) {
        $rem = $x % 2;
        $x >>= 1;
        ++$num
    }

    print "$num\n";
}

1;
