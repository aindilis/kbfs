package KBFS::Tracker;

use Moose;

use KBFS::Tracker::File;
use KBFS::Tracker::FileClass;
use KBS2::Client;
use KBS2::Util;
use PerlLib::SwissArmyKnife;

use Data::Dumper;
use Storable qw(dclone);

has Debug =>
  (
   is => 'rw',
   isa => 'Str',
   default => sub { 0 },
  );

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
  print Dumper({Assert => \%args});
  # return;
  my $filename = $self->Chase(Filename => $args{Filename});
  if (-f $filename) {
    my $file = KBFS::Tracker::File->new
      (
       Filename => $filename,
      );

    $self->EnsureContextIsSet(Context => $args{Context});
    my @assertions;
    foreach my $assertion (@{$args{Assertions}}) {
      push @assertions, $self->SubstituteVariables
	(
	 Expr => DeDumper(Dumper($assertion)),
	 Subst => [
		   {
		    Is => Var('?_'),
		    ShouldBe => ($args{Class} ? $file->FileClass->FileClassID : $file->FileID),
		   },
		  ],
	);
    }
    print Dumper({Assertions => \@assertions});
    foreach my $assertion (@assertions) {
      my %sendargs =
	(
	 Assert => [$assertion],
	 Context => $self->Context,
	 QueryAgent => 1,
	 InputType => "Interlingua",
	 Flags => {
		   # AssertWithoutCheckingConsistency => 1,
		  },
	);
      print Dumper(\%sendargs);
      my $res = $self->MyClient->Send(%sendargs);
      print Dumper({AssertResult => $res});
    }
    if ($args{Class}) {
      KBFS::Tracker::FileClass::Classes->Save;
    } else {
      KBFS::Tracker::File::Files->Save;
    }
  } else {
    # throw not a file
    print "File not found\n";
  }
}

sub RetrieveStatements {
  my ($self, %args) = @_;
  print Dumper({Retrieve => \%args}) if $self->Debug;
  # return;
  foreach my $filename (@{$args{Filenames}}) {
    if (-f $filename) {
      my $file = KBFS::Tracker::File->new
	(
	 Filename => $filename,
	);
      print Dumper({MyFile => $file}) if $self->Debug;
      $self->EnsureContextIsSet(Context => $args{Context});
      my @matches;
      my $message = $self->MyClient->Send
	(
	 QueryAgent => 1,
	 Command => "all-asserted-knowledge",
	 Context => $self->Context,
	);
      if (defined $message) {
	my $assertions = $message->{Data}->{Result};
	foreach my $assertion (@$assertions) {
	  if ($self->MatchFormula
	      (
	       Expr => $assertion,
	       Formula => ($args{Class} ? $file->FileClass->FileClassID : $file->FileID), # $file->FileID,
	      )) {
	    push @matches, $assertion;
	  }
	}
      } else {
	return {
		Success => 0,
	       };
      }
      return {
	      Success => 1,
	      Result => \@matches,
	     };
    } else {
      print "File not found\n";
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
      print "SUBST: ". Dumper($e)."\n".Dumper($substitution->{Is})."\n------------\n\n\n"
	if $self->Debug;
      if (DumperQuote2($e) eq DumperQuote2($substitution->{Is})) {
	return $substitution->{ShouldBe};
      }
    }
    return $e;
  }
}

sub MatchFormula {
  my ($self, %args) = @_;
  print Dumper({MatchFormulaArgs => \%args}) if $self->Debug > 2;
  my $e = $args{Expr};
  my $ref = ref $e;
  if (DumperQuote2($e) eq DumperQuote2($args{Formula})) {
    return 1;
  }
  if ($ref eq "ARRAY") {
    foreach my $item (@$e) {
      if ($self->MatchFormula
	  (
	   Expr => $item,
	   Formula => $args{Formula},
	  )) {
	print "BINGO!\n" if $self->Debug;
	return 1;
      }
    }
  }
}

sub EnsureContextIsSet {
  my ($self, %args) = @_;
  print "ERROR\n" unless $args{Context};
  my $context = $self->Context || "";
  if (exists $args{Context} and $args{Context} ne $context) {
    $self->Context($args{Context});
    $self->MyClient
      (KBS2::Client->new
       (
	Context => $self->Context,
	Debug => $args{Debug},
       ));
  }
}

1;
