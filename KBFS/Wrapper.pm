package KBFS::Wrapper;
use XML::Twig;

use strict;
use Carp;
use vars qw($VERSION);

$VERSION = '1.00';

use Class::MethodMaker new_with_init => 'new',
  get_set => [ qw / URI CacheDir Objects Index Output / ];

sub init {
  my ($self,%args) = (shift,@_);
  $self->URI($args{URI});
  $self->AddCacheDir(CacheDir => $args{CacheDir});
  $self->AddIndex(Index => "$args{CacheDir}/index");
  $self->AddOutput(Output => "$args{CacheDir}/output");
}

sub AddCacheDir {
  my ($self,%args) = (shift,@_);
  # check that cache dir exists
  $self->CacheDir($args{CacheDir});
  if (! -d $self->CacheDir) {
    # create cache dir
    system "mkdirhier " . $self->CacheDir;
  }
}

sub AddIndex {
  my ($self,%args) = (shift,@_);
  # check that index file exists
  $self->Index($args{Index});
  if (! -d $self->Index) {
    system "touch " . $self->Index;
  }
}

sub AddOutput {
  my ($self,%args) = (shift,@_);
  # check that index file exists
  $self->Output($args{Output});
  if (! -d $self->Output) {
    system "touch " . $self->Output;
  }
}

sub Update {
  my ($self,%args) = (shift,@_);
  # check whether file already exists, and when it was last written, if more than 1 day old
  my @stats = stat($self->Index);
  my $diff = time - $stats[9];
  if (-f $self->Index and -s $self->Index) {
    if ($diff > 86400) {
      print $self->Index ." file more than one day old, updating\n";
      $self->RetrieveIndex;
      return 1;
    } else {
      print $self->Index . " file less than one day old, not updating\n";
    }
  } else {
    print "no " . $self->Index . " file, updating\n";
    $self->RetrieveIndex;
    return 1;
  }
  return 0;
}

sub RetrieveIndex {
  my ($self,%args) = (shift,@_);
  system "lynx -source ". $self->URI ." > " . $self->Index;
}

sub Extract {
  my ($self,%args) = (shift,@_);
  exit 0;
  my $twig = XML::Twig->new(           twig_handlers =>
				       {
					span     => sub { RetrieveObject($_)  }, # output and free memory
				       },
				       pretty_print => 'indented');

  $twig->parsefile($self->Index);

  open(FILE,">".$self->Output) or
    die "can't open output file ". $self->Output . "\n";

  foreach my $source (sort keys %{$self->Objects}) {
    print FILE $source."\n" if validate($source);
  }

  close(FILE);
}

sub Validate {
  my ($self,%args) = (shift,@_);
  my $source = shift;
  return $source =~ /^(((::[A-Za-z]+)|([A-Za-z]+::))((::|[A-Za-z])+))$/;
}

sub RetrieveObject {
  my ($self,%args) = (shift,@_);
  my $span = shift;
  my $li = $span->parent;
  if ((defined $li->atts->{'class'}) && ($li->atts->{'class'} eq "verifiedsite")) {
    if ((defined $span->atts->{'class'}) && ($span->atts->{'class'} eq "url")) {
      foreach my $line (split(/\n/,$span->text)) {
	if ($line =~ /^deb/) {
	  chomp $line;
	  $line =~ s/\s+/ /;
	  $self->Objects->{$line} = 1;
	}
      }
    }
  }
}

1;
