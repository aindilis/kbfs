package KBFS::Tracker2::Fingerprint;

use Moose;

use KBFS::Tracker2::FileClass;
use KBFS::Tracker2::File;

use Data::Dumper;
use File::Fingerprint;

has [qw/MD5 MMagic Size CRC16 CRC32/] =>
  (
   is => 'rw',
  );

has [qw/Filename Basename Extension Lines/] =>
  (
   is => 'rw',
  );

sub Generate {
  my $self = shift;
  my $fingerprintobj = File::Fingerprint->roll( $self->Filename );
  foreach my $key (
		   @{KBFS::Tracker2::FileClass->FileClassKeys},
		   @{KBFS::Tracker2::File->FileKeys},
		  ) {
    next if $key eq 'Filename';
    my $key2 = lc($key);
    $self->$key($fingerprintobj->$key2);
  }
}

__PACKAGE__->meta()->make_immutable();

1;
