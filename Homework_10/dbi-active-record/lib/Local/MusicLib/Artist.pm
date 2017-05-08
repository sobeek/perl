package Local::MusicLib::Artist;

use DBI::ActiveRecord;
use Local::MusicLib::DB::SQLite;

use DateTime;

db "Local::MusicLib::DB::SQLite";

table 'artists';

has_field id => (
    isa => 'Int',
    auto_increment => 1,
    index => 'primary',
    #primary_key => 1,
);

has_field name => (
    isa => 'Str',
    index => 'common',
    default_limit => 100,
);

has_field country => (
    isa => 'Str',
    #default_limit => 100,
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

Для каждого исполнителя требуется хранить:

Уникальный идентификатор
Имя/название исполнителя
Страна - двубуквенный код латиницей (ru, en, us и т.п)
Время добавления. В БД должно храниться как timestamp, в приложении - как объект DateTime
Требуется обеспечить возможность выборки из БД:

по списку идентификаторов
по названию
