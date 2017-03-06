#!/usr/bin/perl

use strict;
use warnings;

=encoding UTF8
=head1 SYNOPSYS
����� ���������� ��������� ������ � ���������.
=head1 run ($str, $substr)
������� ������ ���������� ��������� ������ $substr � ������ $str.
�������� ���������� ��������� � ���� "$count\n"
���� ��������� ��� - �������� "0\n".
�������:
run("aaaa", "aa") - �������� "2\n".
run("aaaa", "a") - �������� "4\n"
run("abcab", "ab") - �������� "2\n"
run("ab", "c") - �������� "0\n"
=cut

sub run {
    my ($str, $substr) = @_;
    my $num = 0;
    my $str_length = length $str;
    my $substr_length = length $substr;

    for (0..$str_length - $substr_length + 1) {
        ++$num if index ($str, $substr, $_) == $_;
    }

    print "$num\n";
}

1;
