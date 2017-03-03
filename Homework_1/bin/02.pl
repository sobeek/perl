#!/usr/bin/perl

use strict;
use warnings;

=encoding UTF8
=head1 SYNOPSYS
���������� ������� �����
=head1 run ($x, $y)
������� ���������� ������� ����� � ��������� [$x, $y].
�������� ��� ������������� ������� ����� � ������� "$value\n"
���� ������� ����� � ��������� ��������� ��� - ������ �� ��������.
�������:
run(0, 1) - ������ �� ��������.
run(1, 4) - �������� "2\n" � "3\n"
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
