package myconst 2.0;
use strict;
no strict 'refs';
use warnings;
#use diagnostics;
#use Exporter 'export_to_level';
#our @ISA = qw/Exporter/;
#our @EXPORT;
#our %EXPORT_TAGS = (foo => [qw(aa bb cc)], bar => [qw(aa cc dd)]);
$\ = "\n";
$" = " ";
#print "@INC";
sub import {
    #my $pkg = undef;
    my $pkg = caller;
    #print $pkg;
    #my $pkg = 'Bar';
    shift;
    return unless @_;
    #if (ref $_[-1] eq 'SCALAR') {
    #    my $pkg_ref = pop @_;
    #    $pkg = $$pkg_ref;
    #    print "PKG: ".$pkg;
    #    print "LAST OF \@_: ". $_[-1]
    #}
    #else {
    #    $pkg = caller;
    #}
    #my $pkg = ref $_[-1] eq 'SCALAR' ? pop : caller;
    my %args = @_;
    #print "$_->$a{$_}" for keys %a;
    for (keys %args) {
        if (my $ref = ref $args{$_}) {
            if ('HASH' eq ref $args{$_}) {
                my $group = $_;
                for (keys $args{$group}) {
                    my $full_name = "${pkg}:::${group}::$_";
                    #my $full_name = "myconst::$key";
                    print "FULL NAME: ".$full_name;
                    #print
                    my $value = $group->{$_};
                    *$full_name = sub { $value };
                    fill_names_table ($pkg, $_, $args{$group});
                }
            }
            else {
                return
            }
        }
        else {
            fill_names_table ($pkg, $_, \%args);
        }
    }
    #myconst->export_to_level(1, @_);

}

sub fill_names_table {
    #no strict 'refs';
    my ($pkg, $key, $group_ref) = @_;
    my $full_name = "${pkg}::$key";
    #my $full_name = "myconst::$key";
    print "FULL NAME: ".$full_name;
    #print
    my $value = $group_ref->{$key};
    #$$_ = 1;
    #print $ZERO;
    *$full_name = sub { $value };
    #push @EXPORT, *$full_name;

}

1;
