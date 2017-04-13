#!/usr/bin/perl

package Local::MatrixMultiplier;
use strict;
use warnings;
use 5.010;
use POSIX ":sys_wait_h";

my %pids = ();
my $product = [];

$SIG{'CHLD'} = sub {
    while ((my $pid = waitpid(-1, WNOHANG)) > 0) {
        my $reader = $pids{$pid}{reader};
        my $line = $pids{$pid}{line};
        my $result = <$reader>;
        chomp $result;
        $product->[$line] = [split / /, $result];
    }
};

sub mult {
    my ($mat_a, $mat_b, $max_child) = @_;
    die $! if !check_matrices($mat_a, $mat_b);
    my $mat_dim = scalar @$mat_a - 1;
    $| = 1;
    my $forks = 0;
    for (0..$mat_dim) {
        my $parent;
        my $child;
        pipe $parent, $child or die;
        if (my $pid = fork) {
            ++$forks;
            close $child;
            $pids{$pid} = {line => $_, reader => $parent};
            if ($forks == $max_child) {
                sleep(1_000_000);
                --$forks
            }
        } else {
            die "cannot fork: $!" unless defined $pid;
            close $parent;
            my $res = calc($mat_a->[$_], $mat_b, $mat_dim);
            print $child $res;
            exit(0);
        }
    }
    wait();
    return $product
}

sub check_matrices {
    my $is_valid = 1;
    my %dims = ();
    for (@_) {
        my $dim = check_dimension ($_);
        if (!$dim) {
            $is_valid = 0;
            last
        }
        $dims{$dim}++;
    }
    $is_valid = 0 if 1 != keys %dims;
    return $is_valid;
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

sub calc {
    my ($mat_a_line, $mat_b, $mat_dim) = @_;
    my @product_line = ();
    for my $column (0..$mat_dim) {
        my $sum = 0;
        $sum += $mat_a_line->[$_] * $mat_b->[$_][$column] for 0..$mat_dim;
        push @product_line, $sum;
    }
    my $product_line = join ' ', @product_line;
    return $product_line;
}

1;
