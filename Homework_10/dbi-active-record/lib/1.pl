#!usr/bin/perl -l
use Local::MusicLib::Album;
use Local::MusicLib::Track;
use Local::MusicLib::Artist;
use Local::MusicLib::DB::SQLite;
use DBI::ActiveRecord::DB;
use DBI::ActiveRecord::Object;
use strict;
use warnings;
use DDP;

#print db 'muslib.db';

my $db = Local::MusicLib::DB::SQLite->instance;
$db->connection;
p $db;
$db->insert("X");

__DATA__
my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = gmtime(1);
my @a = gmtime(1);
print "@a";
print "$hour:$min:$sec";
print sprintf "%02d:%02d:%02d", (gmtime(100))[2,1,0]


our $AUTOLOAD;

sub AUTOLOAD {
    my $program = $AUTOLOAD;
    $program =~ s/.*:://;
    #system($program, @_);
    print $program, @_;
}
date();
who('am', 'i');
ls('-l');
