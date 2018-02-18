package KBFS::Tracker::FileClass;

use Moose;
use MooseX::ClassAttribute;

use PerlLib::Collection;
use PerlLib::SwissArmyKnife;

has Debug =>
  (
   is => 'rw',
   isa => 'Str',
   default => sub { 0 },
  );

class_has 'FileClassKeys' =>
  (
   is => 'ro',
   isa => 'ArrayRef',
   default => sub { [qw/MMagic Size CRC16 CRC32/] }, # MD5
  );

class_has 'Classes' =>
  (
   is => 'rw',
   isa => 'HashRef',
   default => sub {
     my $classes = PerlLib::Collection->new
	 (
	  Type => 'KBFS::Tracker::FileClass',
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
   isa => 'KBFS::Tracker::Fingerprint',
   handles => [@{KBFS::Tracker::FileClass::FileClassKeys}],
  );

has FileClassID =>
  (
   is => 'ro',
   lazy => 1,
   default => sub {
     my $self = shift;
     my $matches = $self->Classes->MatchValuesByProcessor
       (
	Processor => sub {$self->SameP(FileClass => $_[0])},
       );
     print Dumper($matches) if $self->Debug;
     my $count = scalar @$matches;
     if ($count == 1) {
       return $matches->[0]->FileClassID;
     } elsif (! $count) {
       return ["FileClassID", $self->Classes->AddAutoIncrement(Item => $self)];
     } else {
       die "throw error here\n";
     }
   },
  );

sub SameP {
  my ($self, %args) = @_;
  # make sure it is derived from KBFS::Tracker::File
  print Dumper({
		Self => $self,
		Args => \%args,
	       }) if $self->Debug;
  # ref($args{FileClass});
  foreach my $key (@{$self->FileClassKeys}) {
    print Dumper({$key.'2' => $self->Fingerprint->$key}) if $self->Debug;
    print Dumper({$key.'1' => $args{FileClass}->Fingerprint->$key}) if $self->Debug;

    unless ($args{FileClass}->Fingerprint->$key eq $self->Fingerprint->$key) {
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
