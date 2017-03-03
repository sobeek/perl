use strict;
use warnings;

=encoding UTF8
=head1 SYNOPSYS
����� ����������� � ����������� �� 3-� �����
=head1 run ($x, $y, $z)
������� ������ ������������ � ������������� �� 3-� ����� $x, $y, $z.
�������� ����������� � ������������ �����, � ���� "$value1, $value2\n"
�������:
run(1, 2, 3) - �������� "1, 3\n".
run(1, 1, 1) - �������� "1, 1\n"
run(1, 2, 2) - �������� "1, 2\n"
=cut

sub run {
    my ($min, $middle, $max) = sort {$a<=>$b} @_;

    print "$min, $max\n";
}

1;
