package KBFS::Systemize::Index;

# add the ability to move whole directories to certain places when
# their subfiles all conform to a specific rule (such as a dir of
# images)

# automatically compute files that are used by other things

# this system should be rewritten to learn from how the user decides
# to classify entries, and should use both external and internal
# features

# use File::Same;
# use File::MimeInfo;

use Data::Dumper;

require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw ( SortDirectory );
#@EXPORT_OK = qw ( );

use Manager::Dialog qw ( ApproveCommands );
use PerlLib::SwissArmyKnife;

sub SortDirectory {
  my $dir = shift;
  my @commands = ();

  # get safe list
  my @safestuff;
  if (-f "$dir/.sortsafe") {
    @safestuff = sort split /\n/,`cat $dir/.sortsafe`;
  }
  my @files = sort split /\n/,`ls`;

  # remove safestuff from consideration
  @files = SubtractList
    (
     A => \@files,
     B => \@safestuff,
    );

  # remove all backup files
  push @commands, "rm $dir/*~\n";

  # sort file types
  my $commands = {
		  "MV" => "mv --backup=t",
		 };

  my $extensions = {
		     "Images" => {
				  Com => "<MV> <FILES> <DIR>",
				  Dir => "$dir/Media/images/",
				  Exts => "jpg jpeg png tif gif bmp pnm xcf",
				 },
		     "Text" => {
				Com => "<MV> <FILES> <DIR>",
				Dir => "$dir/Media/texts/",
				Exts => "txt do",
			       },
		     "HTML" => {
				Com => "<MV> <FILES> <DIR>",
				Dir => "$dir/Media/htmls/",
				Exts => "html php htm cgi asp",
			       },
		     "Videos" => {
				  Com => "<MV> <FILES> <DIR>",
				  Dir => "$dir/Media/videos/",
				  Exts => "avi mpg mpeg mov wmv flv mp4",
				 },
		     "Audio" => {
				 Com => "<MV> <FILES> <DIR>",
				 Dir => "$dir/Media/audio/",
				 Exts => "mp3 ogg wav au",
				},
		     "Papers" => {
				  Com => "<MV> <FILES> <DIR>",
				  Dir => "$dir/Media/papers/",
				  Exts => "ps pdf ps.Z doc rtf",
				 },
		     "Source Code" => {
				       Com => "<MV> <FILES> <DIR>",
				       Dir => "$dir/Media/source/",
				       Exts => "java cpp sh glade",
				      },
		     "Databases" => {
				     Com => "<MV> <FILES> <DIR>",
				     Dir => "$dir/Media/dbs/",
				     Exts => "mdb sql kbs",
				    },
		     "ISO Images" => {
				      Com => "<MV> <FILES> <DIR>",
				      Dir => "$dir/Media/isos/",
				      Exts => "iso",
				     },
		    "Software" => {
				   Com => "<MV> <FILES> <DIR>",
				   Dir => "$dir/Media/software",
				   Exts => "pl jar exe zip gz tar.bz2 tbz2 tar.gz tgz tar.Z sit bin deb rpm pm patch el lisp xpi js dmg so",
				  },
		    "Data Files" => {
				   Com => "<MV> <FILES> <DIR>",
				   Dir => "$dir/Media/data",
				   Exts => "xls csv xml vcf log",
				  },
		    "Documents" => {
				   Com => "<MV> <FILES> <DIR>",
				   Dir => "$dir/Media/documents",
				   Exts => "ppt djvu odp odt ods",
				  },
		    "Application Files" => {
				   Com => "<MV> <FILES> <DIR>",
				   Dir => "$dir/Media/appfiles",
				   Exts => "pgn opml glabels voy.gz dia kif kcrash",
				  },
# 		     "Software" => {
# 				    Com => "packager <FILES>",
# 				    Exts => "pl jar exe zip gz tar.bz2 tar.gz tgz tar.Z sit bin deb rpm",
# 				   },
		    };

  foreach my $item (keys %$extensions) {
    my $hash = $extensions->{$item};
    foreach my $ext (split / +/,$hash->{Exts}) {
      my @matches = grep(/\.$ext$/i,@files);
      if (@matches) {
	my $files = "";
	foreach my $match (@matches) {
	  $files .= shell_quote("$dir/$match")." ";
	}
	@files = SubtractList
	  (
	   A => \@files,
	   B => \@matches,
	  );

	my $com = $hash->{Com};

	# substitute commands
	foreach my $source (keys %$commands) {
	  my $target = $commands->{$source};
	  $com =~ s/<$source>/$target/g;
	}

	if (exists $hash->{Dir}) {
	  my $targetdir = $hash->{Dir};
	  $com =~ s/<DIR>/$targetdir/g;
	  push @commands, "mkdir -p ".shell_quote($targetdir);
	}

	$com =~ s/<FILES>/$files/;
	# be sure to make the dir, add that

	push @commands, $com;
      }
    }
  }

  foreach my $file (@files) {
    # push @commands, "mv --reply=yes --backup=t $dir/$file $dir/Media/Misc";
  }

  print Dumper(\@commands);

  if (1) {
    ApproveCommands(Commands => \@commands,
		    Method => "parallel");
  }
}

1;

# move all remaining files matching types to their respective directories
# move anything with a filetype of English|ASCII text to media/text
# move anything starting with letterto to letters  #("media/letters/","letterto*")
# move all directories that aren't safe into misc/


# #!/usr/bin/perl -w

# # package Predator::Package::Makefile;

# # the point is that rather than hand to all the classification

# # first method is simply to use some heuristics, as this is the easiest method

# use Dir::List;
# use Data::Dumper;
# use Predator::CodeBases;
# use Cache::File;
# use MyFRDCSA;
# use File::Stat;
# use File::Find::Rule::Permissions;
# use File::Basename;

# my $codebases = Predator::CodeBases->new();
# my $d1;

# sub Generate {
#   ClassificationHeuristics(@_);
# }

# sub ClassificationHeuristics {
#   my ($regex) = (shift);
;#   my $codebase = $codebases->SearchCodeBases(Regex => $regex);
#   $d1 = $codebase->{Releases}->{$codebase->LatestRelease}
#     ->SandboxLocation->CompleteFilename;

#   my $sysname = $codebase->Name;

#   #   my $dir = Dir::List->new();
#   #   my $dirinfo = $dir->dirinfo($d1);

#   # rule 1 - executables scripts go to /usr/bin

#   my @files =
#     File::Find::Rule::Permissions->file()
# 	->permissions(isExecutable => 1, user => 'nobody')
# 	  ->in($d1);

#   my @UsrBin = Prune
#     (
#      Files => \@files,
#      RejectRules => [
# 		     sub {/~$/},
# 		     sub {dirname(shift) ne $d1},
# 		    ],
#     );

#   my @UsrShare;
#   my @UsrShareDoc;
#   my @VarLib;
#   my @Etc;
#   my @EtcCronD;

#   push @install, "cp -ar ".join(" ",map $_, @UsrBin).
#     " \$(DESTDIR)/usr/bin" if @UsrBin;
#   push @install, "cp -ar ".join(" ",map basename($_), @UsrShare).
#     " \$(DESTDIR)/usr/share/$sysname" if @UsrShare;
#   push @install, "cp -ar ".join(" ",map basename($_), @UsrShareDoc).
#     " \$(DESTDIR)/usr/share/doc/$sysname" if @UsrShareDoc;
#   push @install, "cp -ar ".join(" ",map basename($_), @VarLib).
#     " \$(DESTDIR)/var/lib/$sysname" if @VarLib;
#   push @install, "cp -ar ".join(" ",map basename($_), @Etc).
#     " \$(DESTDIR)/etc" if @Etc;
#   push @install, "cp -ar ".join(" ",map basename($_), @EtcCronD).
#     " \$(DESTDIR)/etc/cron.d/" if @EtcCronD;

#   my $install = join("\n",map "\t$_", @install);
#   my $makefile = `cat Makefile.template`;
#   $makefile =~ s/<SYSNAME>/$sysname/;
#   $makefile =~ s/<INSTALL>/$install/;
#   print $makefile;
# }

# sub Prune {
#   my (%args) = (@_);
#   my @accepted;
#   foreach my $file (@{$args{Files}}) {
#     my ($accept,$reject) = (0,0);
#     foreach my $acceptrule (@{$args{AcceptRules} || []}) {
#       $accept += &{$acceptrule}($file);
#     }
#     foreach my $rejectrule (@{$args{RejectRules} || []}) {
#       $reject += &{$rejectrule}($file);
#     }
#     if ($accept or ! $reject) {
#       $file =~ s/^$d1\///;
#       push @accepted, $file;
#     }
#   }
#   return @accepted;
# }

# sub LearnMappings {
#   # read in each Makefile, parse it
#   foreach my $c1 ($codebases->ListCodeBases) {
#     # extract the original version and  compare it to the Makefile and
#     # the stored version
#     foreach my $r1 ($c1->ListReleases) {
#       if ($r1->HasPackage) {
# 	# now we  extract a full  model of the entire  source package,
# 	# and original  source, and learn  rules for this  mapping.

# 	# these will just be some results of heuristics
# 	my $usm = $r1->LoadUpstreamSourceModel;

# 	# for now  we'll just have this  be the Makefile  model
# 	my $spm = $r1->LoadSourcePackageModel;

# 	TrainOnExample($spm,$usm);
#       }
#     }
#   }
#   SaveMappings;
# }

# sub SaveMappings {

# }

# sub TrainOnExample {

# }

# # ClassificationHeuristics(@ARGV);

# LearnMappings(@ARGV);
