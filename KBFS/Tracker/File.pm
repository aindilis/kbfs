package KBFS::Tracker::File;

use Moose;
use MooseX::ClassAttribute;

use PerlLib::Collection;
use PerlLib::SwissArmyKnife;
use KBFS::Tracker::FileClass;
use KBFS::Tracker::Fingerprint;

use Data::Dumper;
use File::Fingerprint;

class_has 'FileKeys' =>
  (
   is => 'ro',
   isa => 'ArrayRef',
   default => sub { [qw/Filename Basename Extension Lines/] },
  );

class_has 'Files' =>
  (
   is => 'ro',
   isa => 'PerlLib::Collection',
   default => sub {
     my $files = PerlLib::Collection->new
       (
	Type => 'KBFS::Tracker::File',
	StorageFile => '/var/lib/myfrdcsa/codebases/internal/kbfs/data/KBFSTrackerFile.dat',
       );
     $files->Contents({});
     $files->Load();
     $files;
   },
  );

has 'Filename' =>
  (
   is => 'ro',
   isa    => 'Str',
  );

has 'FileID' =>
  (
   is => 'ro',
   default => sub {
     my $self = shift;
     ["FileID", $self->Files->AddAutoIncrement(Item => $self)];
   },
  );

has 'Fingerprint' =>
  (
   is => 'ro',
   isa => 'KBFS::Tracker::Fingerprint',
   default => sub {
     my $self = shift;
     my $fingerprint = KBFS::Tracker::Fingerprint->new(Filename => $self->Filename);
     $fingerprint->Generate;
     # print Dumper({Fingerprint1 => $fingerprint}) if $self->Debug;
     return $fingerprint;
   },
   handles => [@{KBFS::Tracker::File::FileKeys}],
  );

has 'FileClass' =>
  (
   is => 'rw',
   # isa => 'KBFS::Tracker::FileClass',
   lazy => 1,
   default => sub {
     my $self = shift;
     KBFS::Tracker::FileClass->new
     	 (
     	  Fingerprint => $self->Fingerprint,
     	 );
   },
  );

sub GuessSameP {
  my ($self, %args) = @_;
  my $file = $args{File};
  # ref($file);

  # do improvements for checking file length

  return 1 if $self->FileClass->SameP(FileClass => $file->FileClass);
  return $self->SameP(File => $args{File})
}

sub SameP {
  my ($self, %args) = @_;  
  # do a byte wise comparison of the file

}

sub FileIDExists {
  my ($self, %args) = @_;
  return exists $self->Files->Contents->{$args{FileID}};
}

__PACKAGE__->meta()->make_immutable();

1;
