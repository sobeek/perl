package Local::MusicLib::Track;

use DBI::ActiveRecord;
use Local::MusicLib::DB::SQLite;

use DateTime;

db "Local::MusicLib::DB::SQLite";

table 'tracks';

has_field id => (
    isa => 'Int',
    auto_increment => 1,
    index => 'primary',
);

has_field name => (
    isa => 'Str',
    index => 'common',
    default_limit => 100,
);

has_field extension => (
    isa => 'Str',
);

has_field duration => (
    isa => 'Str',
    #serializer => sub {$_[0]}, # we got number of seconds
    serializer => sub {
        my ($h, $m, $s) = split(/:/, $_[0]);
        return $h*3600 + $m*60 + $s
    },
    deserializer => sub {sprintf "%02d:%02d:%02d", (gmtime($_[0]))[2,1,0]}
);

has_field create_time => (
    isa => 'DateTime',
    serializer => sub { $_[0]->epoch },
    deserializer => sub { DateTime->from_epoch(epoch => $_[0]) },
);

has_field album_id => (
    isa => 'Int',
    index => 'common',
    default_limit => 100,
);

no DBI::ActiveRecord;
__PACKAGE__->meta->make_immutable();

1;

__DATA__

Для каждого трека требуется хранить:

Уникальный идентификатор
Название трека
Длительность трека. В БД должно храниться как количество секунд, в приложении - как строка вида hh:mm:ss
Время добавления. В БД должно храниться как timestamp, в приложении - как объект DateTime
Идентификатор альбома


Требуется обеспечить возможность выборки из БД:

по списку идентификаторов
по названию
по индетификатору альбома
