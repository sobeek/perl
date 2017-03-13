package SecretSanta;

use 5.010;
use strict;
use warnings;

sub calculate {
    my $input = \@_;
    for (0..10) { # 11 попыток на успешное выполнение

        my $partners = {};
        my $members = [];
        my $candidates = {};
        my $presents = {};

        my @args = ($input, $partners, $members, $candidates, $presents);
        fill(@args);
        shift @args;
        if (gifts_pairs(@args)) {
            my @result = map {[$_, $presents->{$_}]} keys %$presents;
            #p @result;
            return @result;
        }
    }
}

sub fill { # fill %partners, @members, %candidates
    my ($args, $partners, $members, $candidates, $presents) = @_;
    my @args = @$args;

    for (@args) {
        if (ref \$_ eq 'SCALAR') {
            $partners->{$_} = 0;
            push @$members, $_;
        }
        elsif (ref $_ eq 'ARRAY') {
            my @pair = @$_;
            push @$members, @pair;
            for my $index (0..1) {
                my $partner = $pair[$index];
                $partners->{$partner} = $pair[1 - $index];
            }
        }
        else {
            die "Invalid argument!";
        }
    }
    $candidates->{$_} = 1 for @$members;
    $presents->{$_} = 1 for @$members;
}

sub gifts_pairs { #даем на вход ссылки на структуры данных участников
    my ($partners, $members, $candidates, $presents) = @_;
    my $count = 0;
RAND:
    for (@$members) {
        my $rand = int (rand keys %$candidates);

        my $current_participant = $_; #текущий участник
        my $candidate = (keys %$candidates)[$rand]; #кандидат на подарок от текущего участника
        if (
            ($current_participant eq $candidate) #если текущий участник дарит сам себе
            ||
            ($partners->{$current_participant} eq $candidate) #если текущий участник дарит своему супругу
            ||
            ($presents->{$candidate} eq $current_participant) #если кандидат уже подарил подарок текущему участнику
        ) {
            ++$count;
            if ($count > 2*@$members) {
                return 0
            }
            redo RAND
        }
        else {
            $presents->{$current_participant} = $candidate;
            delete $candidates->{$candidate};
            $count = 0;
        }
    }
    return 1;
}

1;
