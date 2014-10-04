package DB::Schema;

use DB::Thing;

my $schema = DBIx::Mint->instance->schema;
$schema->add_class(
     class      => 'DB::Thing',
     table      => 'thing',
     pk         => 'id_thing',
     auto_pk    => 1,
);







1;
