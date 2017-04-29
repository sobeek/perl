#!usr/bin/perl -l

use strict;
use warnings;
use DBI;
use DBD::SQLite;

#my $dbh = DBI->connect("dbi:Pg:dbname=$db_name", $user_name, $password, {AutoCommit => 0, RaiseError => 1});
my $dbh = DBI->connect("dbi:SQLite:dbname=perl.db","","");
#my $dbh = DBI->connect("dbi:SQLite:dbname=perl_lite.db","","");


my @r = (q {DROP TABLE IF EXISTS `users`;},
        q {CREATE TABLE `users` (`id` INTEGER NOT NULL, `first_name` VARCHAR(255) NOT NULL, `last_name` VARCHAR(255) NOT NULL, PRIMARY KEY (`id`));},
        q {DROP TABLE IF EXISTS `relations`;},
        q {CREATE TABLE `relations` (`id_first` INTEGER NOT NULL, `id_second` INTEGER NOT NULL, CONSTRAINT c PRIMARY KEY (id_first, id_second));}
        );
my $number_of_rows = $dbh->do($_) for @r;

#my $f = 'user_lite.txt';
my $f = 'user';


#$f = 'rel.txt';
open my $fh1, $f or die;
while (<$fh1>) {
    my ($id, $first_name, $last_name) = split;
    chomp $last_name;
    my $sth = $dbh->prepare('INSERT INTO USERS VALUES (?, ?, ?)');
    $sth->execute($id, $first_name, $last_name);
}
close(F);

#$f = 'user_relation_lite.txt';
$f = 'user_relation';
open $fh2, $f or die;
my @thousand = ();
my $vars = '';
my $i = 0;
while (<$fh2>) {
    my ($id_first, $id_second) = split;
    chomp $id_second;
    $vars .= "($id_first, $id_second), ";
    ++$i;
    if (0 == $i%1000 || eof) {
        $vars =~ s/, $//;
        eval {$dbh->do('INSERT INTO relations VALUES '.$vars)};
        $vars = '';
    }
}
close (F);
