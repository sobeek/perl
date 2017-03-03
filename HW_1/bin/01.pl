#!/usr/bin/perl

use strict;
use warnings;

=encoding UTF8
=head1 SYNOPSYS
���������� ������ ����������� ��������� a*x**2+b*x+c=0.
=head1 run ($a_value, $b_value, $c_value)
������� ���������� ������ ����������� ���������.
��������� �� ����  ���������� ����������� ��������� $a_value, $b_value, $c_value.
��������� ����� � ���������� $x1 � $x2.
�������� ��������� ���������� � ���� ������ "$x1, $x2\n".
���� ��������� �� ����� ������� ������ ���� ���������� "No solution!\n"
�������:
run(1, 0, 0) - �������� "0, 0\n"
run(1, 1, 0) - �������� "0, -1\n"
run(1, 1, 1) - �������� "No solution!\n"
=cut

sub run {
    my ($a_value, $b_value, $c_value) = @_;

    my $x1 = undef;
    my $x2 = undef;

    my $D = undef;

    $D = $b_value ** 2 - 4 * $a_value * $c_value;
    if ($D < 0 || !$a_value) {
      print "No solution!\n";
      return
    }
    $x1 = (-$b_value + sqrt($D)) / (2 * $a_value);
    $x2 = (-$b_value - sqrt($D)) / (2 * $a_value);

    print "$x1, $x2\n";
}

1;
