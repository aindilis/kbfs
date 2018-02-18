package KBFS;

use BOSS::Config;
use KBFS::Cache;
use KBFS::Pack::Packing;
use KBFS::Systemize::Index;
use Manager::Dialog qw (Message ApproveCommands);
use MyFRDCSA;


use Data::Dumper;

use Class::MethodMaker
  new_with_init => 'new',
  get_set       => [ qw / Config SystemDir LastCommand / ];

sub init {
  my ($self,%args) = @_;
  $specification = "
	-b			Quick backup of FRDCSA to media

	-n <name>		Backup name
	-d <dirs>...		Complex backup of dirs to media
	--untested-feature-f	Follow sym links
	--untested-feature-sim	Simulate run, don't actually make any changes

	-r [<dirs>...]		Rsync backup of dirs to second hard drive

	-m <media>...		Media to use: BD, DVD or CD.  Defaults to BD.

	-i <dirs>...		Digest and organize (systematize) directories
	-s <search>		Search media backup index

	-l <lic> <files>...     Set license for files
	-u [<host> <port>]	Agentify
";
  $self->Config(BOSS::Config->new
		(Spec => $specification,
		 ConfFile => ""));
  my $conf = $self->Config->CLIConfig;
  if (exists $conf->{'-u'}) {
    $UNIVERSAL::agent->Register
      (Host => defined $conf->{-u}->{'<host>'} ?
       $conf->{-u}->{'<host>'} : "localhost",
       Port => defined $conf->{-u}->{'<port>'} ?
       $conf->{-u}->{'<port>'} : "9000");
  }
  $self->SystemDir
    ($self->ChooseFirst
     ("/var/lib/kbfs",
      ConcatDir(Dir("internal codebases"),"kbfs")));
}

sub ChooseFirst {
  my ($self,@dirs) = @_;
  while (my $dir = shift @dirs) {
    return $dir if -d $dir or -f $dir;
  }
}

sub Execute {
  my ($self,%args) = @_;
  my $conf = $self->Config->CLIConfig;
  if (exists $conf->{'-d'}) {
    $self->ComplexBackup(Directories => $conf->{'-d'});
  }
  if (exists $conf->{'-r'}) {
    my $list = $conf->{'-r'};
    if (! scalar @$list) {
      $list =
	[
	 "/var/lib/mysql",
	 "/var/lib/myfrdcsa",
	];
    }
    $self->RsyncBackup
      (Directories => $list);
  }
  if (exists $conf->{'-b'}) {
    $self->MakeDVD();
  }
  if (exists $conf->{'-i'}) {
    $self->Systemize
      (
       Dirs => $conf->{'-i'},
      );
  }
  if (exists $conf->{'-s'}) {
    $self->Search(Search => $conf->{'-s'});
  }
}

sub MakeDVD {
  my ($self,%args) = @_;
  ApproveCommands
    (Method => 'parallel',
     Commands =>
     ["sudo /sbin/modprobe ide-scsi",
      # FIXME: should this be genisoimage instead of mkisofs?
      "mkisofs -o /tmp/backup.iso -r -graft-points ".
      "/var/lib/myfrdcsa/codebases/releases=/var/lib/myfrdcsa/codebases/releases",
      # "/var/lib/myfrdcsa/codebases/work=/var/lib/myfrdcsa/codebases/work ".
      # "/var/lib/myfrdcsa/projects=/var/lib/myfrdcsa/projects",
      "dvdrecord dev=0,0,0 -dao /tmp/backup.iso"]);
}

sub ComplexBackup {
  my ($self,%args) = @_;
  my $conf = $self->Config->CLIConfig;
  my $media = {};
  if (scalar @{$conf->{'-m'}}) {
    foreach my $item (@{$conf->{'-m'}}) {
      if ($item eq 'BD') {
	$media->{"BD-R"} = 23;
      }
      if ($item eq 'DVD') {
	$media->{"DVD-R"} = 30;
      }
      if ($item eq 'CD') {
	$media->{"CD-RW"} = 5;
      }
    }
  } else {
    $media->{'BD-R'} = 23;
  }
  my $packing = KBFS::Pack::Packing->new
    (KBFS::Pack::DirectoryTree->new($args{Directories}),
     KBFS::Pack::MediaStruct->new
     ($media));
  $packing->pack;
  $packing->visualize;
}

sub RsyncBackup {
  my ($self,%args) = @_;
  my $mountpoint = "/mnt/hdc2";
  my @commands;
  foreach my $dir (@{$args{Directories}}) {
    if (-d $dir) {
      if ($dir !~ q|^/|) {
	my $wd = `pwd`;
	chomp $wd;
	$dir = ConcatDir($wd,$dir);
      }
      $dir =~ s|/$||;
      my $destdir = $dir;
      $destdir =~ s|/[^/]+$||;
      $destdir = ConcatDir
	($mountpoint,$destdir);
      if (! -d $destdir) {
	push @commands, "mkdirhier \"$destdir\"";
      }
      push @commands, "sudo rsync -av \"$dir\" \"$destdir\"";
    }
  }
  ApproveCommands
    (Commands => \@commands,
     Method => "parallel");
}

sub Search {
  my ($self,%args) = @_;
  my $search = $args{Search};
  system "zgrep -i $search /var/lib/myfrdcsa/codebases/internal/kbfs/data/index-media/*.gz";
}

sub FreeSpace {
  # locate large files and directories, and especially unmodified
  # unzipped archives and prompt for removal
}

sub ProcessCommand {
  my ($self,$command) = @_;
  $self->LastCommand($command);
}

sub Systemize {
  my ($self,%args) = @_;
  print Dumper(\%args);
  foreach my $dir (@{$args{Dirs}}) {
    SortDirectory($dir);
  }
}

1;
