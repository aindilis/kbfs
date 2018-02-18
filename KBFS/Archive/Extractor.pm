package KBFS::Archive::Extractor;

# NOT YET FINISHED

use Manager::Dialog qw (Message ApproveCommands);

use Data::Dumper;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       => [ qw / / ];

sub init {
  my ($self,%args) = @_;
}

sub Execute {
  my ($self,%args) = @_;
  my $file = $args{File};
  my $extractiondir = $args{ExtractionDir}; # or create a temp dir for
                                            #  it, and return that dir
  my $command;
  my @order = qw (tgz tar.z tar.gz tar.bz2 tbz2 bz2 zip tar jar rar);
  my %commands = (
		  tgz => "tar -xzf <FILE>",
		  "tar.z" => "tar -xzf <FILE>",
		  "tar.gz" => "tar -xzf <FILE>",
		  "tar.bz2" => "tar -xjf <FILE>",
		  tbz2 => "tar -xjf <FILE>",
		  bz2 => "bzip2 -d <FILE>",
		  zip => "unzip <FILE>",
		  rar => "unrar x <FILE>",
		  tar => "tar -xvf <FILE>",
		  jar => "mkdir tmp; cp <FILE> tmp",
		 );
  my $virgin = 1;
  foreach my $key (@order) {
    if ($file =~ /\.${key}$/i) {
      if ($virgin) {
	$virgin = 0;
	my $curcom = $commands{$key};
	$curcom =~ s|<FILE>|\"$file\"|;
	$command = "mkdir -p ".$extractiondir." && ".
	  "cd ".$extractiondir." && $curcom";
	if (ApproveCommand($command)) {
	  # now check that it is in the apropriate place
	  chdir $extractiondir;
	  my @files = split /\n/,`ls`;
	  if (0) {
	    if (scalar @files > 1 ) {
	      ApproveCommand("mkdir ".$self->DirName." && mv * ".$self->DirName);
	    } elsif (scalar @files == 1) {
	      ApproveCommand("mv \"".$files[0]."\" ".$self->DirName);
	    } else {
	      print "WTF?!";
	    }
	  }
	  Message(Message => "Extracted");
	  return 1;
	}
      }
    }
  }
}

1;
