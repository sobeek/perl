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

sub dumper {
    return undef unless $supported;
    
    my $what = shift;
    $what =~ /\(.*\)/ if (defined $what);
    my $what_address = $& || 1;
    my $what_from = shift || 0;

    if ($what_address eq $what_from) {
        return $what;
    }

    if (my $ref = ref $what) {
        given ($ref) {
            when ('ARRAY') {
                my $array = [];
                for (@$what) {
                    my $res = dumper($_, $what_address);
                    $supported ? push @$array, $res : return undef;
                }
                return $array;
            }
            when ('HASH') {
                my $hash = {};
                while (my ($k, $v) = each %$what) {
                    #print $depth;
                    my $res = dumper($v, $what_address);
                    $supported ? $hash->{$k} = $res : return undef;
                }
                #p $hash;
                #<>;
                return $hash;
            }
            default {
                $supported = 0;
                return undef;
            }
        }
    }
    else {
		#print $what;
        return $what;
    }
}

sub clone {
	my $orig = shift;
	my $cloned;

	$cloned = dumper $orig;
    #p $cloned;
	return $supported ? $cloned : undef;
}

1;
