package KBFS::Tracker::Fingerprint;

use Moose;

use KBFS::Tracker::FileClass;
use KBFS::Tracker::File;

use Data::Dumper;
use File::Fingerprint;

has [qw/MMagic Size CRC16 CRC32/] => # MD5 
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
		   @{KBFS::Tracker::FileClass->FileClassKeys},
		   @{KBFS::Tracker::File->FileKeys},
		  ) {
    next if $key eq 'Filename';
    my $key2 = lc($key);
    $self->$key($fingerprintobj->$key2);
  }
}

__PACKAGE__->meta()->make_immutable();

1;
