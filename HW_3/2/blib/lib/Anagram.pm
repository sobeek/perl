package Anagram;

use 5.010;
use strict;
use warnings;
use Encode qw(from_to decode encode);
use DDP;
#use utf8;

=encoding UTF8
=head1 SYNOPSIS
����� ��������
=head1 anagram($arrayref)
������� ������ ���� �������� �������� �� �������.
������� ������ ��� �������: ������ �� ������ - ������ ������� �������� - ����� �� ������� ����� � ��������� utf8
�������� ������: ������ �� ��� �������� ��������.
���� - ������ ������������� � ������� ����� �� ���������
�������� - ������ �� ������, ������ ������� �������� ����� �� ���������, � ��� ������� � ������� ��� ����������� � ������� � ������ ��� (��� ������ ������ ����������������� �� �����������.)
��������� �� ������ �������� �� ������ ������� � ���������.
��� ����� ������ ���� ��������� � ������� ��������.
� �������������� ��������� ������ ����� ������ ����������� ������ ���� ���.
��������
anagram(['�����', '������', '�����', '����', '�����', '������', '�����', '������', '������'])
������ ������� ������ �� ���
{
    '�����'  => ['�����', '�����', '�����'],
    '������' => ['������', '������', '������'],
}
=cut

#binmode STDOUT, ":utf8";

sub anagram {
    my $words_list = shift;
    my %result;
    my $match;

    my @words_list = @$words_list;
    for (0..$#words_list) {
        my $current_word = decode('utf8', $words_list[$_]);
        #my $current_word = $words_list[$_];
        #say utf8::is_utf8 $current_word;
        $current_word = lc $current_word;
        #print '$_:'.$current_word;
        $match = join '', sort split //, $current_word;
        #print "MATCH: ". $match;

        $result{$match}{first_value} = $current_word unless exists $result{$match};
        $result{$match}{$current_word} = $_ unless exists $result{$match}{$current_word};
        #push @{$result{$match}}, lc $_;

    }

    #p %result;
    for (keys %result) {
        #$k = 1;
        my $k = $_;
        my $v = $result{$k};
        if (2 == keys %$v) {
            delete $result{$k};
            next
        }
        #<>;
        #p $v;
        my $first_value = $v->{first_value};
        #print  "FIRST VALUE: $first_value";
        delete $v->{first_value};
        if ($k ne $first_value) {
            $result{$first_value} = $v;
            delete $result{$k};
        }
        #keys %$v = map {encode('utf8', $_)} keys %$v;
        $result{$first_value} = [sort keys %$v];
        #keys %$v = sort {$b cmp $a} keys %$v;
    }
    keys %result = map {encode('utf8', $_)} keys %result;
    p %result;
    return \%result;
}

1;
