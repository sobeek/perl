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

#$, = " ";

sub dumper;

#my $supported = undef;

sub dumper {
    my ($what, $supported, $vizited_addresses) = @_;
    return (undef, $supported) unless $supported;
    #$what =~ /\(.*\)/ if (defined $what);
    my $what_address = $what ? "$what" : 1;
    if (exists $vizited_addresses->{$what_address}) {
        my $what_copy = $what;
        return ($what_copy, $supported);
    }
    else {
        $vizited_addresses->{$what_address} = 1
    }

    if (my $ref = ref $what) {
        given ($ref) {
            when ('ARRAY') {
                my $array = [];
                for (@$what) {
                    my ($res, $supported) = dumper($_, $supported, $vizited_addresses);
                    #print $res, $supported;
                    $supported ? push @$array, $res : return (undef, $supported);
                }
                return ($array, $supported);
            }
            when ('HASH') {
                my $hash = {};
                while (my ($k, $v) = each %$what) {
                    my ($res, $supported) = dumper($v, $supported, $vizited_addresses);
                    #print $supported;
                    $supported ? $hash->{$k} = $res : return (undef, $supported);
                }
                return ($hash, $supported);
            }
            default {
                $supported = 0;
                #print $supported;
                return (undef, $supported);
            }
        }
    }
    else {
        #print $what;
        return ($what, $supported);
    }
}

sub clone {
	my $orig = shift;
	my $cloned;
    my $supported = 1;
    my $vizited_addresses = {};

	($cloned, $supported) = dumper ($orig, $supported, $vizited_addresses);
	return $supported ? $cloned : undef;
}

1;
