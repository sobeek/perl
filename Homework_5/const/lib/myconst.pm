package myconst;

use strict;
no strict 'refs';
use warnings;
require Exporter;
use Scalar::Util 'looks_like_number';

sub import {
    my $caller = caller;
    shift;
    die "invalid args checked" if 1 == @_ % 2;
    my %args = @_;
    for (keys %args) {
        if (my $ref = ref $args{$_}) { #если встретили группу
            if ('HASH' eq ref $args{$_}) { #если реально группа
                my $group = $_;
                for (keys $args{$group}) {
                    if (check_args ($_, $args{$group}->{$_})) {
                        push @{"${caller}::EXPORT_OK"}, $_;
                        fill_names_table ($caller, $_, $args{$group});
                    }
                    else {
                        die "invalid args checked"
                    }
                }
                ${"${caller}::EXPORT_TAGS"}{$group} = [keys $args{$group}];
            }
            else {
                die "invalid args checked"
            }
        }
        else {
            if (check_args ($_, $args{$_})) {
                push @{"${caller}::EXPORT_OK"}, $_;
                fill_names_table ($caller, $_, \%args);
            }
            else {
                die "invalid args checked"
            }
        }
    }

    ${"${caller}::EXPORT_TAGS"}{all} = [@{"${caller}::EXPORT_OK"}];
    *{"${caller}::import"} = \&Exporter::import;
}

sub check_args {
    my ($key, $value) = @_; # just key and value from %args
    if (ref $value || looks_like_number($key) || $key !~ /^\w+$/) {
        return 0
    }
    return 1;
}

sub fill_names_table {
    my ($caller, $key, $group_ref) = @_;
    my $full_name = "${caller}::$key";
    my $value = $group_ref->{$key};
    *{$full_name} = sub () {$value};
}

1;
