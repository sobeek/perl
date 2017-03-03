use strict;
use warnings;

=encoding UTF8
=head1 SYNOPSYS
����� ������ ������� �� �������� ����.
=head1 run ($x)
������� ������ ������� �� �������� ���� � 32-������ ����� (����� 0).
�������� ����� ������� �� �������� ���� � ���� "$num\n"
�������:
run(1) - �������� "0\n".
run(4) - �������� "2\n"
run(6) - �������� "1\n"
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
