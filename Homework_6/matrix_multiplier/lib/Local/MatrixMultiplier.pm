#!/usr/bin/perl

package Local::MatrixMultiplier;
use strict;
use warnings;
use 5.010;
use DDP;
use Parallel::ForkManager;

sub mult {
    my ($mat_a, $mat_b, $max_child) = @_;

    my $product = [];
    if (my $dim_a = check_matrix($mat_a) and my $dim_b = check_matrix($mat_b)) {
        die $! if $dim_a != $dim_b
    }
    else {
        die $!
    }
    my $x = scalar @$mat_a - 1;

    my $pm = Parallel::ForkManager->new($max_child);

    $pm->run_on_finish( sub {
        my ($pid, $exit_code, $ident, $exit_signal, $core_dump, $data_structure_reference) = @_;
        my $a = $data_structure_reference->{a};
        my $b = $data_structure_reference->{b};
        $product->[$a][$b] = $data_structure_reference->{result};
    });

    for my $ind_a (0..$x) {
        for my $ind_b (0..$x) {
            my $pid = $pm->start and next;
            my $res = calc($mat_a, $mat_b, $ind_a, $ind_b, $x);
            $pm->finish(0, { a => $ind_a, b => $ind_b, result => $res });
        }
    }

    $pm->wait_all_children;
    return $product;
}

sub check_matrices {
    #my ($a, $b) = @_;
    my $is_valid = 1;
    my %dims = ();
    for (@_) {
        p $_;
        my $dim = check_dimension ($_);
        if (!$dim) {
            $is_valid = 0;
            last
        }
        $dims{$dim}++;
        #last if !$dim;
    }
    if (!$is_valid || 1 != keys %dims) {
        return 0
    }
    else {
        return 1
    }
}

sub check_dimension {
    my $matrix = shift;
    my $lines_number = scalar @$matrix;
    my $is_valid = 1;
    for (@$matrix) {
        if ($lines_number != scalar @$_) {
            $is_valid = 0;
            last
        }
    }
    return $is_valid ? $lines_number : 0;
}

sub check_matrix {
    my $matrix = shift;
    my $lines_number = scalar @$matrix;
    for (@$matrix) {
        return undef if $lines_number != scalar @$_;
    }
    return $lines_number;
}

sub calc {
    my ($mat_a, $mat_b, $ind_a, $ind_b, $x) = @_;
    my $sum = 0;
    $sum += $mat_a->[$ind_a][$_] * $mat_b->[$_][$ind_b] for 0..$x;
    return $sum;
}

1;
