package Local::MusicLib::DB::MySQL;
use Mouse;
extends 'DBI::ActiveRecord::DB::AnyDB';

sub _build_connection_params {
    my ($self, $user, $password) = @_;
    return [
        'dbi:mysql:dbname=./muslib.db', $user, $password, {}
    ];
}

no Mouse;
__PACKAGE__->meta->make_immutable();

1;
