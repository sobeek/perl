package Anagram;

use 5.010;
use strict;
use warnings;
use Encode qw(from_to decode encode);
use DDP;

=encoding UTF8
=head1 SYNOPSIS
Поиск анаграмм
=head1 anagram($arrayref)
Функцию поиска всех множеств анаграмм по словарю.
Входные данные для функции: ссылка на массив - каждый элемент которого - слово на русском языке в кодировке utf8
Выходные данные: Ссылка на хеш множеств анаграмм.
Ключ - первое встретившееся в словаре слово из множества
Значение - ссылка на массив, каждый элемент которого слово из множества, в том порядке в котором оно встретилось в словаре в первый раз (или Массив должен быть отсортирован по возрастанию.)
Множества из одного элемента не должны попасть в результат.
Все слова должны быть приведены к нижнему регистру.
В результирующем множестве каждое слово должно встречаться только один раз.
Например
anagram(['пятак', 'ЛиСток', 'пятка', 'стул', 'ПяТаК', 'слиток', 'тяпка', 'столик', 'слиток'])
должен вернуть ссылку на хеш
{
    'пятак'  => ['пятак', 'пятка', 'тяпка'],
    'листок' => ['листок', 'слиток', 'столик'],
}
=cut

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
        $result{$match}{$current_word} = $_ unless exists $result{$match}{$current_word}; #позиция первого вхождения слова в словарь
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
        for (keys %$v) {
            $v->{encode('utf8', $_)} = $v->{$_};
            delete $v->{$_};
        }
        $result{$first_value} = [sort keys %$v];
        #keys %$v = sort {$b cmp $a} keys %$v;
    }
    for (keys %result) {
        $result{encode('utf8', $_)} = $result{$_};
        delete $result{$_};
    }
    #keys %result = map {encode('utf8', $_)} keys %result;
    p %result;
    return \%result;
}

1;
