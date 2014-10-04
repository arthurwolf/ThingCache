package DB::Thing;
use Moo;
with 'DBIx::Mint::Table';
   
has id_thing             => (is => 'rw' );
has native_thing_id      => (is => 'rw' );
has url                  => (is => 'rw' );
has site_id              => (is => 'rw' );
has author_name          => (is => 'rw' );
has description          => (is => 'rw' );
has instructions         => (is => 'rw' );
has license              => (is => 'rw' );
has published            => (is => 'rw' );
has tittle               => (is => 'rw' );

1;
