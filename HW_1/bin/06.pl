#!/usr/bin/perl

use strict;
use warnings;

=encoding UTF8
=head1 SYNOPSYS
Шифр Цезаря https://ru.wikipedia.org/wiki/%D0%A8%D0%B8%D1%84%D1%80_%D0%A6%D0%B5%D0%B7%D0%B0%D1%80%D1%8F
=head1 encode ($str, $key)
Функция шифрования ASCII строки $str ключем $key.
Пачатает зашифрованную строку $encoded_str в формате "$encoded_str\n"
Пример:
encode('#abc', 1) - печатает '$bcd'
=cut

sub encode {
    my ($str, $key) = @_;
    my $encoded_str = '';

    my $str_length = length $str;

    my $char = '';
    my $encoded_char = '';
    my $encoded_char_num = 0;

    for (0..$str_length - 1) {
        $char = substr $str, $_, 1;
        $encoded_char_num = (ord($char) + $key) % 128;
        $encoded_char = chr $encoded_char_num;
        $encoded_str .= $encoded_char;
    }

    print "$encoded_str\n";
}

#encode('Howto learn perl?', 127);
#__DATA__

=head1 decode ($encoded_str, $key)
Функция дешифрования ASCII строки $encoded_str ключем $key.
Пачатает дешифрованную строку $str в формате "$str\n"
Пример:
decode('$bcd', 1) - печатает '#abc'
=cut

sub decode {
    my ($encoded_str, $key) = @_;
    encode ($encoded_str, 128 - $key);
}

1;
