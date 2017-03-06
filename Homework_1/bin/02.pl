#!/usr/bin/perl

use strict;
use warnings;

=encoding UTF8
=head1 SYNOPSYS
Вычисление простых чисел
=head1 run ($x, $y)
Функция вычисления простых чисел в диапазоне [$x, $y].
Пачатает все положительные простые числа в формате "$value\n"
Если простых чисел в указанном диапазоне нет - ничего не печатает.
Примеры:
run(0, 1) - ничего не печатает.
run(1, 4) - печатает "2\n" и "3\n"
=cut

sub is_prime {
    my $num = shift;
    return 0 if $num < 2;
    for (2..sqrt($num)) {
        $num % $_ == 0 ? return 0 : next;
    }
    return 1
}

sub run {
    my ($x, $y) = @_;
    $, = "\n";
    print grep {is_prime($_)} ($x..$y);
}

1;
