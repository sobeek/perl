#!usr/bin/perl -l

use strict;
use warnings;
use DBI;
use DBD::SQLite;
use DDP;
use JSON::XS;
use Getopt::Long;
use FindBin;
use lib "$FindBin::Bin/../lib";
use Local::SocialNetworkMember;

use 5.010;
use Encode qw/encode decode/;
use Config::Simple;

my $config_file = '../config/config';
#open F, $config_file or die;
my %config;
Config::Simple->import_from($config_file, \%config);
p %config;

my @conf = ($config{'SQLite.type'}, $config{'SQLite.name'}, $config{'SQLite.user'}, $config{'SQLite.password'});

#p @conf;

my @user_ids = ();
#my $db_name = shift @ARGV;
my $option = shift @ARGV;
GetOptions ("user=i" => \@user_ids);
#print $db_name;
#print @user_ids;
my $connected;

my ($dbh, $sth);

$dbh = SocialNetworkMember::connect_to_data_base(@conf);

sub get_data_by_id {
    my $user_id = shift;
    #print $user_id;
    my $query = 'SELECT * FROM users WHERE id = ?';
    $sth = $dbh->prepare($query);
    #my @users = ();
    #for (@user_ids) {
    $sth->execute($user_id);
    my $hash_ref = $sth->fetchrow_hashref();
    return $hash_ref
}

sub create_objects {
    my $num_obj = shift;
    my @res = ();
    for (0..$num_obj-1) {
        push @res, SocialNetworkMember->new(
            #db_name => $db_name,
            %{get_data_by_id($user_ids[$_])}
        );
    }
    return @res;
}

my $res;

print "$option of @user_ids:";

if ('nofriends' eq $option) {
    $res = SocialNetworkMember::nofriends($dbh);
}
else {
    my ($user_one, $user_two) = create_objects(2);
    given ($option) {
        when ('friends') {
            $res = $user_one->friends($user_two, $dbh);
        }
        when ('num_handshakes') {
            $res = $user_one->num_handshakes($user_two, $dbh);
        }
        default {
            die "Unknown option!"
        }
    }
}

#print $res;
if ('ARRAY' eq ref $res) {
    my $result_array = [];
    for (@$res) {
        #warn $_;
        push @$result_array, decode ('utf8', JSON::XS::encode_json get_data_by_id($_))
    }
    p $result_array
}
else {
    print $res
}


#print @ARGV;
#print $db_name;
#__DATA__
