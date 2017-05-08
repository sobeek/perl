package Local::MusicLib::DB::SQLite;
use Mouse;
extends 'DBI::ActiveRecord::DB::AnyDB';

sub _build_connection_params {
    my ($self) = @_;
    print 1;
    return [
        'dbi:SQLite:dbname=./muslb.db', '', '', {}
    ];
}

no Mouse;
__PACKAGE__->meta->make_immutable();

1;
