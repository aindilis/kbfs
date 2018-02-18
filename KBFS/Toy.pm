package KBFS::Toy;

use Manager::Dialog qw (Message ApproveCommands);

use Data::Dumper;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       => [ qw / / ];

sub init {
  my ($self,%args) = @_;
  my $informationtopossiblycollect =
    [
     "KBS rules/triggers applying to this file",
     "Which physical device the file is stored on (for calculations about transfer speeds to other devices).",
     "Permissions of the File",
     "Classification of the File",
     "Tags about the File",
     "Type of file (text, binary, etc), MIME, etc",
     "File name, containing directory and directory structure",
     "Source of the file (e.g. Internet site, youtube, etc.)",
     [
      "If the file is a text file or can be partially converted to such",
      "Text classification Tags about the File",
      "LOC classification of the File",
      "ACM classification of the File",
      "Proposed goals in the file (in other words, the audience processing)",
      "Add terminology to Termios, cross link termios data with the file, or a copy of the file",
      "Sayer analysis of file contents",
      "Index with QUAC",
     ],
     [
      "If the file is an audio file",
      "ASR results on the file",
      "Emotional quality of the file",
      ["if the audio file is a song",
       "Lyrics to the song",
       "All MP3 tags or equivalent metadata",
      ],
     ],
     [
      "If the file is a video file",
      "All audio file informations",
      "OCR of all frames",
      "Safety classification of film (PG13, etc.)",
      ],
     [
      "If the file is an ontology",
      "Check whether it already exists",
      "Possibly load into a unique location",
     ],
    ];
}

sub ProcessCommand {
  my ($self,@dirs) = @_;
  # ls "/kbfs/movies containing 'I love you'/"
  # ls "/kbfs/texts about artificial intelligence/"
  if ($args{Command} =~ /^ls \/kbfs\/(.+)$/) {
    my $search = $1;
    print Dumper($search);
  }
}

sub BuildKBAboutFiles {
  my ($self,%args) = @_;
  my $files = {};
  my $dirs = {};
  if (exists $args{Files}) {
    foreach my $file (@{$args{Files}}) {
      if (-f $file) {
	$files->{$file}++;
      } else {
	print "no such file: <<<$file>>>\n";
      }
    }
  }
  if (exists $args{Dirs}) {
    foreach my $dir (@{$args{Dirs}}) {
      if (-d $dir) {
	$dirs->{$dir}++;
	foreach my $item (split /\n/, `find "$dir"`) {
	  if (-f $item) {
	    $files->{$item}++;
	  } elsif (-d $item) {
	    $dirs->{$item}++;
	  } else {
	    print "no such file: <<<$file>>>\n";
	  }
	}
      } else {
	print "no such directory: <<<$dir>>>\n";
      }
    }
  }
  print Dumper({
		Files => $files,
		Dirs => $dirs,
	       });

  # now process these files with the associated command
  
}

sub Execute {
  my ($self,%args) = @_;
  my $conf = $self->Config->CLIConfig;
  if (exists $conf->{'-d'}) {

  }
}

1;
