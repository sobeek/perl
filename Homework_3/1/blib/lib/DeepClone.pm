package DeepClone;

use 5.010;
use strict;
use warnings;

=encoding UTF8
=head1 SYNOPSIS
Клонирование сложных структур данных
=head1 clone($orig)
Функция принимает на вход ссылку на какую либо структуру данных и отдаюет, в качестве результата, ее точную независимую копию.
Это значит, что ни один элемент результирующей структуры, не может ссылаться на элементы исходной, но при этом она должна в точности повторять ее схему.
Входные данные:
* undef
* строка
* число
* ссылка на массив
* ссылка на хеш
Элементами ссылок на массив и хеш, могут быть любые из указанных выше конструкций.
Любые отличные от указанных типы данных -- недопустимы. В этом случае результатом клонирования должен быть undef.
Выходные данные:
* undef
* строка
* число
* ссылка на массив
* ссылка на хеш
Элементами ссылок на массив или хеш, не могут быть ссылки на массивы и хеши исходной структуры данных.
=cut

sub dumper;

sub dumper {
    my $what = shift;
    my $depth = shift || 0;
    if (my $ref = ref $what) {
        #print $ref;
        given ($ref) {
            when ('ARRAY') {
                my $array = [];
                push @$array, dumper($_, $depth + 1) for @$what;
                return $array;
            }
            when ('HASH') {
                my $hash = {};
                while (my ($k, $v) = each %$what) {
                    #print " "x$depth, "$k:";
                    $hash->{$k} = dumper($v, $depth + 1);
                }
                #p $hash;
                #<>;
                return $hash;
            }
            default {
                die "unsupported: $ref"; }
        }
    }
    else {
        #print " "x$depth, $what;
        return $what;
    }
}

sub clone {
	my $orig = shift;
	my $cloned;

	$cloned = dumper $orig;
	return $cloned;
}

1;
