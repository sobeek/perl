package myconst 2.0;
use DDP;
use strict;
no strict 'refs';
use warnings;
#use diagnostics;
require Exporter;
our @ISA = ("Exporter");
#our @ISA = qw/Exporter/;
$\ = "\n";
$" = " ";
our %EXPORT_TAGS;
our @EXPORT_OK;

#print "@INC";
sub import {
    #my $pkg = undef;

    my $pkg = caller;
    warn "CALLER: ". $pkg;
    #my $pkg = 'Bar';
    shift;
    return unless @_;
    #warn @_;
    my %args = @_;
    #print "$_->$a{$_}" for keys %a;
    for (keys %args) {
        if (my $ref = ref $args{$_}) {
            if ('HASH' eq ref $args{$_}) {
                my $group = $_;
                #print;
                $EXPORT_TAGS{$group} = [keys $args{$group}];
                ${"${pkg}::EXPORT_TAGS"}{$group} = [keys $args{$group}];
                for (keys $args{$group}) {
                    #my $full_name = "${pkg}::${group}::$_";
                    #my $full_name = "myconst::$key";
                    #print "FULL NAME: ".$full_name;
                    push @{"${pkg}::EXPORT_OK"}, $_;
                    push @EXPORT_OK, $_;
                    fill_names_table ($pkg, $_, $args{$group});
                }
            }
            else {
                print "Invalid arguments";
                return
            }
        }
        else {
            push @{"${pkg}::EXPORT_OK"}, $_;
            push @EXPORT_OK, $_;
            fill_names_table ($pkg, $_, \%args);
        }
    }

    ${"${pkg}::EXPORT_TAGS"}{all} = [@{"${pkg}::EXPORT_OK"}];
    $EXPORT_TAGS{all} = [@EXPORT_OK];
    #print @EXPORT_OK;
    warn;
    #$EXPORT_TAGS{all} = [@EXPORT_OK];
    #print %{"${pkg}::EXPORT_TAGS"};

    #print qq/@{"${pkg}::EXPORT_OK"}/;
    #myconst->export_to_level(1, @EXPORT_OK);

}

sub fill_names_table {
    #no strict 'refs';
    my ($pkg, $key, $group_ref) = @_;
    #use Data::Dumper;
    #warn Dumper $group_ref;
    #warn $key;
    my $full_name = "${pkg}::$key";
    #warn $full_name;
    #my $full_name = "myconst::$key";
    #print "FULL NAME: ".$full_name;
    #print
    my $value = $group_ref->{$key};
    #warn $value;
    #$$_ = 1;
    #print $ZERO;
    *{$full_name} = sub {$value};
    #*{$key} = sub {$value}
}

1;
