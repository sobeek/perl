use strict;
use warnings;

=encoding UTF8
=head1 SYNOPSYS
ѕоиск наименьшего и наибольшего из 3-х чисел
=head1 run ($x, $y, $z)
‘ункци€ поиска минимального и максимального из 3-х чисел $x, $y, $z.
ѕачатает минимальное и максимальное числа, в виде "$value1, $value2\n"
ѕримеры:
run(1, 2, 3) - печатает "1, 3\n".
run(1, 1, 1) - печатает "1, 1\n"
run(1, 2, 2) - печатает "1, 2\n"
=cut

sub run {
    my ($min, $middle, $max) = sort {$a<=>$b} @_;

    print "$min, $max\n";
}

1;
