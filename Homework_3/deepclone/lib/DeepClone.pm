package DeepClone;

use 5.010;
use strict;
use warnings;
use DDP;

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

my $supported = 1;
my %vizited_addresses = ();

sub dumper {
    return undef unless $supported;

    my $what = shift;
    $what =~ /\(.*\)/ if (defined $what);
    my $what_address = $& || 1;
    if (exists $vizited_addresses{$what_address}) {
        return $what;
    }
    else {
        $vizited_addresses{$what_address} = 1
    }

    if (my $ref = ref $what) {
        given ($ref) {
            when ('ARRAY') {
                my $array = [];
                for (@$what) {
                    my $res = dumper($_);
                    $supported ? push @$array, $res : return undef;
                }
                return $array;
            }
            when ('HASH') {
                my $hash = {};
                while (my ($k, $v) = each %$what) {
                    my $res = dumper($v);
                    $supported ? $hash->{$k} = $res : return undef;
                }
                return $hash;
            }
            default {
                $supported = 0;
                return undef;
            }
        }
    }
    else {
        return $what;
    }
}

sub clone {
	my $orig = shift;
	my $cloned;

	$cloned = dumper $orig;
	return $supported ? $cloned : undef;
}

1;
