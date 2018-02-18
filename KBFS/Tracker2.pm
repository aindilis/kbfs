package KBFS::Tracker2;

use Moose;

use KBFS::Tracker2::File;
use KBFS::Tracker2::FileClass;
use KBS2::Client;
use KBS2::Util;
use PerlLib::SwissArmyKnife;

use Data::Dumper;
use Storable qw(dclone);

has Context =>
  (
   is => 'rw',
  );

has MyClient =>
  (
   is => 'rw',
   isa => 'KBS2::Client',
  );

sub AssertStatementsAboutFile {
  my ($self, %args) = @_;
  $self->AssertStatements
    (
     Class => 0,
     %args,
    );
}

sub AssertStatementsAboutFileClass {
  my ($self, %args) = @_;
  $self->AssertStatements
    (
     Class => 1,
     %args,
    );
}

sub Chase {
  my ($self, %args) = @_;
  my $filename = $args{Filename};
  if ($filename =~ /^~\/(.+)$/s) {
    $filename = $ENV{HOME}."/$1";
  }
  print $filename."\n";
  return $filename;
  my $command = 'chase '.shell_quote($filename);
  my $result = `$command`;
  chomp $result;
  return $result;
}

sub AssertStatements {
  my ($self, %args) = @_;
  my $filename = $self->Chase(Filename => $args{Filename});
  if (-f $filename) {
    my $file = KBFS::Tracker2::File->new
      (
       Filename => $filename,
      );
    print "ERROR\n" unless $args{Context};
    if ($args{Context} ne $self->Context) {
      $self->Context($args{Context});
      $self->MyClient
	(KBS2::Client->new
	 (
	  Context => $self->Context,
	  Debug => $args{Debug},
	 ));
    }
    my @assertions;
    foreach my $assertion (@{$args{Assertions}}) {
      push @assertions, $self->SubstituteVariables
	(
	 Expr => DeDumper(Dumper($assertion)),
	 Subst => [
		   {
		    Is => "var", # \*{'main::?_'},
		    ShouldBe => ($args{Class} ? $file->FileClass->FileClassID : $file->FileID),
		   },
		  ],
	);
    }
    print Dumper({Assertions => \@assertions});
    foreach my $assertion (@assertions) {
      my %sendargs =
	(
	 Assert => $assertion,
	 Context => $self->Context,
	 QueryAgent => 1,
	 InputType => "Interlingua",
	 Flags => {
		   AssertWithoutCheckingConsistency => 1,
		  },
	);
      print Dumper(\%sendargs);
      my $res = $self->MyClient->Send(%sendargs);
      print Dumper({AssertResult => $res});
    }
    if ($args{Class}) {
      KBFS::Tracker2::FileClass::Classes->Save;
    } else {
      KBFS::Tracker2::File::Files->Save;
    }
  } else {
    # throw not a file
  }
}

sub RetrieveStatements {
  my ($self, %args) = @_;
  foreach my $filename (@{$args{Filenames}}) {
    if (-f $filename) {
      my $file = KBFS::Tracker2::File->new
	(
	 Filename => $filename,
	);
      
    }
  }
}

sub SubstituteVariables {
  my ($self, %args) = @_;
  my $e = $args{Expr};
  my $ref = ref $e;
  if ($ref eq "ARRAY") {
    my @res;
    foreach my $item (@$e) {
      push @res, $self->SubstituteVariables
	(
	 Expr => $item,
	 Subst => $args{Subst},
	);
    }
    return \@res;
  } else {
    foreach my $substitution (@{$args{Subst}}) {
      # print Dumper($e)."\n".Dumper($substitution->{Is})."\n------------\n\n\n";
      if (DumperQuote2($e) eq DumperQuote2($substitution->{Is})) {
	return $substitution->{ShouldBe};
      }
    }
    return $e;
  }
}

1;
