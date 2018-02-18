package KBFS::Tracker2::FileClass;

use Moose;
use MooseX::ClassAttribute;

use PerlLib::Collection;

class_has 'FileClassKeys' =>
  (
   is => 'ro',
   isa => 'ArrayRef',
   default => sub { [qw/MD5 MMagic Size CRC16 CRC32/] },
  );

class_has 'Classes' =>
  (
   is => 'rw',
   isa => 'HashRef',
   default => sub {
     my $classes = PerlLib::Collection->new
	 (
	  Type => 'KBFS::Tracker2::FileClass',
	  StorageFile => '/var/lib/myfrdcsa/codebases/internal/kbfs/data/KBFSTrackerFileClass.dat',
	 );
     $classes->Contents({});
     $classes->Load();
     $classes;
   },
  );

has 'Fingerprint' =>
  (
   is => 'ro',
   isa => 'KBFS::Tracker2::Fingerprint',
   handles => [@{KBFS::Tracker2::FileClass::FileClassKeys}],
  );

has FileClassID =>
  (
   is => 'ro',
   default => sub {
     my $self = shift;
     ["FileClassID", $self->Classes->AddAutoIncrement(Item => $self)];
   },
  );

sub SameP {
  my ($self, %args) = @_;
  # make sure it is derived from KBFS::Tracker2::File
  # ref($args{FileClass});
  foreach my $key (@{self->ClassKeys}) {
    unless ($args{FileClass}->$key eq $self->$key) {
      return 0;
    }
  }
  return 1;
}

sub FileClassIDExists {
  my ($self, %args) = @_;
  return exists $self->Classes->Contents->{$args{FileClassID}};
}

__PACKAGE__->meta()->make_immutable();

1;
