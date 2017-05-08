package Local::MusicLib::Album;

use DBI::ActiveRecord;
use Local::MusicLib::DB::SQLite;

use DateTime;

db "Local::MusicLib::DB::SQLite";

table 'albums';

has_field id => (
    isa => 'Int',
    auto_increment => 1,
    index => 'primary',
);

has_field artist_id => (
    isa => 'Int',
    index => 'common',
    default_limit => 100,
);

has_field name => (
    isa => 'Str',
    index => 'common',
    default_limit => 100,
);

has_field release_year => (
    isa => 'Int',
);

has_field album_type => (
    isa => 'Str',
    default_limit => 100,
);

has_field create_time => (
    isa => 'DateTime',
    serializer => sub { $_[0]->epoch },
    deserializer => sub { DateTime->from_epoch(epoch => $_[0]) },
);

no DBI::ActiveRecord;
__PACKAGE__->meta->make_immutable();

1;

__DATA__

Для каждого альбома требуется хранить:

Уникальный идентификатор
Идентификатор исполнителя
Название альбома
Год издания
Тип альбома: сингл, саундтрек, сборник, обычный альбом (валидацию делаем на уровне приложения)
Время добавления. В БД должно храниться как timestamp, в приложении - как объект DateTime
Требуется обеспечить возможность выборки из БД:

по списку идентификаторов
по названию
по индетификатору исполнителя
