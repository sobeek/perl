package SecretSanta;

use 5.010;
use strict;
use warnings;
use DDP;

my %partners = ();
my @members = ();
my %candidates = ();
my %presents = ();

sub calculate {
    #my ($args) = @_;
    for (0..10) { # 11 ������� �� �������� ����������
        fill(\@_);
        #print "CANDIDATES: ";
        #p %candidates;
        if (gifts_pairs(@members)) {
            my @result = map {[$_, $presents{$_}]} keys %presents;
            #p @result;
            return @result;
        }
        @members = ();
    }
    #print "It seems to be impossible to distribute gifts";
}

sub fill { # ��������� %partners, @members, %candidates
    my ($args) = @_;
    my @args = @$args;
    for (@args) {
        if (ref \$_ eq 'SCALAR') {
            $partners{$_} = 0;
            push @members, $_;
        }
        elsif (ref $_ eq 'ARRAY') {
            my @pair = @$_;
            push @members, @pair;
            for my $index (0..1) {
                my $partner = $pair[$index];
                $partners{$partner} = $pair[1 - $index];
            }
        }
        else {
            die "Invalid argument!";
        }
    }
    $candidates{$_} = 1 for @members;
    $presents{$_} = 1 for @members;
}

sub gifts_pairs { #���� �� ���� ������ ���������� @members
    my $count = 0;
RAND:
    for (@_) {
        my $rand = int (rand keys %candidates);

        my $current_participant = $_; #������� ��������
        my $candidate = (keys %candidates)[$rand]; #�������� �� ������� �� �������� ���������
        #print $current_participant, $candidate;

        if (
            ($current_participant eq $candidate) #���� ������� �������� ����� ��� ����
            ||
            ($partners{$current_participant} eq $candidate) #���� ������� �������� ����� ������ �������
            ||
            ($presents{$candidate} eq $current_participant) #���� �������� ��� ������� ������� �������� ���������
        ) {
            #print "NEXT";
            ++$count;
            if ($count > 2*@_) {
                #print "FAIL...";
                return 0
            }
            redo RAND
        }
        else {
            $presents{$current_participant} = $candidate;
            delete $candidates{$candidate};
            $count = 0;
        }
        #p %presents;
        #p %candidates;
        #<>;
    }
    return 1;
}

1;
