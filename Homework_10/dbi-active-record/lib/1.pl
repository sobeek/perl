#!usr/bin/perl -l
use Local::MusicLib::Album;
use Local::MusicLib::Track;
use Local::MusicLib::Artist;
use Local::MusicLib::DB::SQLite;
use DBI::ActiveRecord::DB;
use DBI::ActiveRecord;
use strict;
use warnings;
use DDP;

#print db 'muslib.db';

my $x = DBI::ActiveRecord::Object->new();

=head1 track testing
my $track = Local::MusicLib::Track->new(id => 1, name => "x", extension => ".mp3", duration => "00:02:13", create_time => DateTime->new(year => 2014, month => 02, day => 02), album_id => 1);

$track->insert();
$track->delete();
$track->update();
$track->select("name", "x");

=cut

=head1 album testing

my $album = Local::MusicLib::Album->new(id => 1, artist_id => 2, name => "x", release_year => 2018, album_type => "OST", create_time => DateTime->new(year => 2014, month => 02, day => 02));

#$album->insert();
#$album->delete();
#$album->update();
p $album->select("name", "x");

=cut

=head1 artist testing

my $artist = Local::MusicLib::Artist->new(id => 1, name => "e", country => "ru", create_time => DateTime->new(year => 2014, month => 02, day => 02));

#$artist->insert();
#$artist->delete();
#$artist->update();
#p $artist->select("name", "z");

=cut
