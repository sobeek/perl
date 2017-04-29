#!usr/bin/perl -l

use strict;
use warnings;
use DBI;
use DBD::SQLite;
use DDP;
use JSON::XS;
use Getopt::Long;

package SocialNetworkMember;

sub new {
    my $invocant = shift;
    my $class = ref($invocant) || $invocant;
    my $self = { @_ };          # Оставшиеся аргументы становятся атрибутами
    bless($self, $class);       # «Благословление» в объекты
    return $self;
}

my $connected = 0;

sub connect_to_data_base {
    my ($type, $db_name, $user, $password) = @_;
    #print @_;
    #my $db_name = shift;
    my $dbh;
    eval {
        $dbh = DBI->connect("dbi:$type:$db_name",$user,$password, { RaiseError => 1 });
        #print 1;
    } or do {
        die
    };
    $connected = 1;
    #print 1;
    return $dbh
}

sub get_friends {
    my ($id, $dbh) = @_;
    #my $dbh = connect_to_data_base if !$connected;
    my $query = 'SELECT id_second FROM relations WHERE id_first = ?
                UNION
                SELECT id_first FROM relations WHERE id_second = ?';
    #print $query;
    my $sth = $dbh->prepare($query);
    $sth->execute($id, $id);
    my $response = [];
    while (my @row = $sth->fetchrow_array()) {
        #print "@row";
        push @$response, @row;
    }
    return $response
}

sub num_handshakes {
    my $dbh = pop;
    my ($from, $to) = map { $_->{id} } @_;
    my @queue = ($from);
    my %used = ();
    my %depth = ();
    #my %parents = ();
    $used{$from} = 1;
    #$parents{$from} = -1;
    while (@queue) {
        my $current_node = shift @queue;
        my $current_node_friends = get_friends($current_node, $dbh);
        for (@$current_node_friends) {
            #my $to = $_;
            if (!$used{$_}) {
                $used{$_} = 1;
                push @queue, $_;
                $depth{$_} = 1 + ($depth{$current_node} // 0);
                #$parents{$to} = $_;
                return $depth{$_} if $_ == $to;
                #is_member($to, $current_node_friends)
            }
        }
    }
    return "isolated"
}

sub nofriends {
    #my $dbh = connect_to_data_base; # if !$connected;
    my $dbh = shift;
    my $query = 'SELECT id FROM users';
    #print $query;
    my $sth = $dbh->prepare($query);
    $sth->execute();
    my $response = [];
    while (my @row = $sth->fetchrow_array()) {
        #print "@row";
        my $id = shift @row;
        my $id_friends = get_friends($id, $dbh);
        push @$response, $id if !@$id_friends;
    }
    return $response
}

sub friends {
    #print @_;
    my $dbh = pop;
    my ($id_first, $id_second) = map { $_->{id} } @_;
    return get_common_friends($id_first, $id_second, $dbh);
}

sub get_common_friends {
    my ($id_first, $id_second, $dbh) = @_;
    #my %id_second_friends = ();
    my $friends_first = get_friends($id_first, $dbh);
    my $friends_second = get_friends($id_second, $dbh);
    my %id_first_friends = map {$_ => 1} @$friends_first;
    my %id_second_friends = map {$_ => 1} @$friends_second;
    my @common_friends = grep {$id_first_friends{$_}} @$friends_second;
    return \@common_friends;
}

1;
