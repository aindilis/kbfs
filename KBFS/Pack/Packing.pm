package KBFS::Pack::Packing;
use strict;
use KBFS::Pack::DirectoryTree;
use KBFS::Pack::MediaStruct;

use PerlLib::SwissArmyKnife;

sub new {
  my $that  = shift;
  my $class = ref($that) || $that;
  my $self = {
	      DIRECTORYTREE => undef,
	      MEDIASTRUCT => undef,
	      SOLVABLE => undef,
	      DIR_SOLVABLE => undef,
	      CLOSEST_DIR => undef,
	      CLOSEST_MEDIA => undef,
	      PACKING => {},
	      DIRQUEUE => [],
	      MEDIAQUEUE => [],
	     };
  bless($self, $class);

  my $tmp = shift;
  if ($tmp ne "") {
    $self->directorytree($tmp);
  }
  $tmp = shift;
  if ($tmp ne "") {
    $self->mediastruct($tmp);
  }
  $tmp = shift;
  if (defined($tmp)) {
    $self->solvable($tmp);
  } else {
    $self->solvable(1);
  }
  $tmp = shift;
  if (defined($tmp)) {
    $self->dir_solvable($tmp);
  } else {
    $self->dir_solvable(1);
  }
  $tmp = shift;
  if (defined($tmp)) {
    $self->closest_dir($tmp);
  }
  $tmp = shift;
  if (defined($tmp)) {
    $self->closest_media($tmp);
  }
  $tmp = shift;
  if (defined($tmp)) {
    $self->packing($tmp);
  }
  $tmp = shift;
  if (defined($tmp)) {
    $self->dirqueue($tmp);
  }
  $tmp = shift;
  if (defined($tmp)) {
    $self->mediaqueue($tmp);
  }
  return $self;
}

use Alias qw(attr);
our ($DIRECTORYTREE,$MEDIASTRUCT,$SOLVABLE,$DIR_SOLVABLE,$CLOSEST_DIR,$CLOSEST_MEDIA,%PACKING,@DIRQUEUE,@MEDIAQUEUE);

sub directorytree {
  my $self = attr shift;
  if (@_) { 
    $DIRECTORYTREE = shift;
  }
  return    $DIRECTORYTREE;
}

sub mediastruct {
  my $self = attr shift;
  if (@_) { 
    $MEDIASTRUCT = shift;
  }
  return    $MEDIASTRUCT;
}

sub solvable {
  my $self = attr shift;
  if (@_) { 
    $SOLVABLE = shift;
  }
  return    $SOLVABLE;
}

sub dir_solvable {
  my $self = attr shift;
  if (@_) {
    $DIR_SOLVABLE = shift;
  }
  return    $DIR_SOLVABLE;
}

sub closest_dir {
  my $self = attr shift;
  if (@_) { 
    $CLOSEST_DIR = shift;
  }
  return    $CLOSEST_DIR;
}

sub closest_media {
  my $self = attr shift;
  if (@_) { 
    $CLOSEST_MEDIA = shift;
  }
  return    $CLOSEST_MEDIA;
}

sub packing {
  my $self = attr shift;
  if (@_) { 
    shift;
    %PACKING = %{$_}
  }
  return    \%PACKING;
}

sub dirqueue {
  my $self = attr shift;
  if (@_) { 
    my $it = shift;
    @DIRQUEUE = @{$it};
  }
  return    \@DIRQUEUE;
}

sub mediaqueue {
  my $self = attr shift;
  if (@_) { 
    my $it = shift;
    @MEDIAQUEUE = @{$it};
  }
  return    \@MEDIAQUEUE;
}



sub pack {
  my $self = attr shift;
  if (ref $self) {
    $self->directorytree->index_dirs;
    $self->mediastruct->index_media;
    $self->solve;
  }
}

sub solve {
  my $self = attr shift;
  if (ref $self) {
    $self->dirqueue([sort {$a->size <=> $b->size} values %{$self->directorytree->all_directories}]);
    $self->mediaqueue([sort {$a->size <=> $b->size} values %{$self->mediastruct->medias}]);

    # this handles the iteration over increasing media
    while ($self->solvable && @{$self->dirqueue} && @{$self->mediaqueue}) {
      print "possible solutions remain\n";
      print @{$self->dirqueue} . " directories remaining\n";
      if (scalar @{$self->dirqueue} == 1) {
	if (defined $self->dirqueue->[0] and
	    ref($self->dirqueue->[0]) eq 'KBFS::Pack::Directory' and
	    defined $self->dirqueue->[0]->name) {
	  print "Possible Pariah: ".$self->dirqueue->[0]->name."\n";
	}
      }
      print @{$self->mediaqueue} . " media remaining\n";
      $self->greedy_fill_media;
    }
    print "no possible solutions remain\n";
  }
}

sub greedy_fill_media {

  # each invocation of  greedy_fill_media should: select the optimal
  # assignment to one media and remove it 

  my $self = attr shift;
  if (ref $self) {
    # $self->show_queues;
    $self->select_optimal_media;
    $self->fill_media;
    $self->remove_media_from_queue;
  }
}

sub select_optimal_media {

  # each  invocation of  select_optimal_media should:  determine the
  # optimal media,  by walking up  the sorted sizes of  dirqueue and
  # mediaqueue, and marking the least 

  my $self = attr shift;
  if (ref $self) {
    $self->solvable(0);
    my ($i,$j,$diff,$closest) = (0,0,0,$self->mediastruct->largestmediasize);
    while (($i < @{$self->dirqueue}) &&
	   ($j < @{$self->mediaqueue})) {
      my $d = $self->dirqueue->[$i];
      my $m = $self->mediaqueue->[$j];
      my $diff = ($m->size - $d->size);
      if ((0 <= $diff) && ($diff <= $closest)) {
	$closest = $diff;
	$self->closest_dir($d);
	$self->closest_media($m);
	$self->solvable(1);
      }
      if ($diff > 0) {
	++$i;
      } else {
	++$j;
      }
    }
  }
}

sub fill_media {

  # this attempts  now, given that we  know $self->closest_media, to
  # fill the remainder of that media must only affect setting of $closest_dir

  my $self = attr shift;
  if (ref $self) {
    $self->dir_solvable(1);
    $self->add_dir_to_media;
    while ($self->dir_solvable) {
      $self->select_optimal_dir;
      $self->add_dir_to_media;
    }
  }
}

sub add_dir_to_media {
  my $self = attr shift;
  if (ref $self) {
    if ((ref $self->closest_dir) && (ref $self->closest_media)) {
      # add dir to media and remove from queue
      if (!($self->closest_media->add_file($self->closest_dir))) {
	$self->remove_dir_from_queue;
      } else {
	$self->dir_solvable(0);
      }
    }
  }
}

sub select_optimal_dir {

  # each  invocation of  select_optimal_dir should:  determine the
  # optimal dir,  by walking up  the sorted sizes of  dirqueue and
  # mediaqueue, and marking the least 

  my $self = attr shift;
  if (ref $self) {
    $self->dir_solvable(0);
    # if (defined $self->closest_media && $self->closest_media ne "") {
    my ($i,$j,$diff,$closest) = (0,0,0,$self->closest_media->free_space);
    while (($i < @{$self->dirqueue}) && (!$j)) {
      my $d = $self->dirqueue->[$i];
      my $diff = $self->closest_media->free_space - $d->size;
      if ((0 <= $diff) && ($diff <= $closest)) {
	$closest = $diff;
	$self->closest_dir($d);
	$self->dir_solvable(1);
      }
      if ($diff >= 0) {
	++$i;
      } else {
	$j = 1;
      }
    }
    # }
  }
}

sub remove_media_from_queue {
  my $self = attr shift;
  if (ref $self) {
    $self->mediaqueue($self->subtract($self->closest_media,$self->mediaqueue));
    $self->closest_media("");
  }
}

sub compare {
  my ($a, $b) = @_;
  # if (defined $a) {
  #   if (! defined $a->size) {
  #     $a->{CHILDREN} = [];
  #     die Dumper({NotDefinedSizeA => $a});
  #   } else {
  #     print "Undefined A\n";
  #   }
  # }
  # if (defined $b) {
  #   if (! defined $b->size) {
  #     $b->{CHILDREN} = [];
  #     die Dumper({NotDefinedSizeB => $b});
  #   } else {
  #     print "Undefined B\n";
  #   }
  # }
  my $res = $a->size <=> $b->size;
  return $res;
}

sub remove_dir_from_queue {
  my $self = attr shift;
  if (ref $self) {
    # do all obligatory stuff
    my @list = grep {defined $_->size} $self->closest_dir->list_all_parentdirs;
    push @list, $self->closest_dir->list_all_subdirs;
    my @dirs_to_remove = sort {compare($a,$b)} @list;
    # my @dirs_to_remove = sort {$a->size <=> $b->size} @list;
    $self->dirqueue($self->major_subtract(\@dirs_to_remove,$self->dirqueue));
    $self->closest_dir("");
  }
}

sub major_subtract {
  my $self = attr shift;
  my $a = shift;
  my $b = shift;
  my @list = @$b;
  foreach my $dir (@$a) {
    @list = @{$self->subtract($dir,\@list)};
  }
  return \@list;
}

sub subtract {
  my $self = attr shift;
  if (@_) {
    my $key = shift;
    my $list = shift;

    my $index = $self->lindex($key,$list);
    if ($index ne -1) {
      splice @$list,$index,1;
      #print "<<$index,$key>>\n"
    } else {
      #print "Error: no match\n";
    }
    return $list;
  }
}

sub lindex {
  my $self = attr shift;
  if (@_) {
    my $key = shift;
    my $list = shift;

    my $match = -1;
    my $i = 0;
    while (($i < @$list) && ($match == -1)) {
      if ($list->[$i] eq $key) {
	$match = $i;
      }
      ++$i;
    }
    return $match;
  }
}

sub uniq {
  my $self = attr shift;
  if (ref $self && @_) {
    my $dir = shift;
    if (-e $dir) {
      my $i = 0;
      while (-e "$dir-$i") {
	++$i;
      }
      return "$dir-$i";
    } else {
      return $dir;
    }
  }
}

sub visualize {
  my $self = attr shift;
  print "Beginning Visualization\n";
  if (ref $self) {
    my @targetdirs;
    my @names;
    my $items = {};
    my $count = 0;
    foreach my $media (values %{$self->mediastruct->medias}) {
      if ($media->used_space) {
	++$count;
      }
    }
    my $i = 0;
    foreach my $media (values %{$self->mediastruct->medias}) {
      if ($media->used_space) {
	++$i;
	my $name = "disk-$i-of-$count";
	$items->{$name} =
	  {
	   I => $i,
	   Count => $count,
	   Media => $media,
	  };
	my $script = "";
	my $targetdir;

	push @names, $name;
	if ($media->type eq 'DVD-R') {
	  $targetdir = $self->uniq("/tmp/".$media->type);
	  $items->{$name}{TargetDir} = $targetdir;
	  $script .= "mkdir $targetdir\n";
	} elsif ($media->type eq 'BD-R') {
	  $targetdir = "/mnt/udf";
	  if (! -d "/mnt/udf") {
	    $script .= "sudo mkdir /mnt/udf\n";
	  }
	}
	foreach my $dir (sort {$a->name cmp $b->name} values %{$media->contains}) {
	  if (-d $dir->name) {
	    $script .= "sudo mkdirhier ".shell_quote($targetdir.$dir->name)."\n";
	    $script .= "sudo rmdir ".shell_quote($targetdir.$dir->name)."\n";
	  }
	  $script .= "sudo cp -ar ".shell_quote($dir->name)." ".shell_quote($targetdir.$dir->name)."\n";
	}
	$items->{$name}{Script} = $script;
	$script .= "\n";
      }
    }
    my $run;
    foreach my $name (sort keys %$items) {
      if ($items->{$name}{Media}->type eq 'DVD-R') {
	print "$name\n";

	# approve this command
	my $dir = $items->{$name}{TargetDir};

	print $items->{$name}{Script};
	system $items->{$name}{Script};

	print "genisoimage -R -f -o $dir.iso $dir\n";
	print "time dvdrecord -dao dev=0,0,0 $dir.iso\n";
	print "rm $dir.iso\n";
      } elsif ($items->{$name}{Media}->type eq 'BD-R') {
	# now this
	my $datadir = "/var/lib/myfrdcsa/codebases/internal/kbfs/data";
	unless ($run) {
	  $run = 1;
	  while (-d $datadir.'/runs/'.$run) {
	    ++$run;
	  }
	  system "mkdir -p ".shell_quote($datadir.'/runs/'.$run);
	}
	my $fh = IO::File->new();
	$fh->open(">$datadir/runs/$run/generate-$name.sh") or die "cannot open file\n";

	print $fh "#!/bin/sh\n";

	my $backupname = $UNIVERSAL::kbfs->Config->CLIConfig->{'-n'} || 'general';
	$backupname =~ s/[^-A-Za-z0-9_]+/_/sg;
	my $date = DateTimeStamp();

	# now do the stuff here
	my $imgfile = shell_quote($datadir.'/runs/'.$run.'/FRDCSA-'.$backupname.'-'.$date.'-'.$name.'.udf');
	my $volname = shell_quote("FRDCSA $backupname $date ".$items->{$name}{I}.' OF '.$items->{$name}{Count});
	my $cddevice = '/dev/sr0';

	print $fh "imgfile=$imgfile
volname=$volname
cddevice=$cddevice

";

	print $fh
	  'sudo truncate --size=23075M "$imgfile"

imgloop=`sudo losetup -f`

sudo losetup "$imgloop" "$imgfile"

sudo cryptsetup luksFormat --cipher aes-xts-plain64 "$imgloop"

# enter the password in here

sudo cryptsetup luksOpen "$imgloop" mybluray

sudo mkudffs --vid="$volname" /dev/mapper/mybluray

sudo mount /dev/mapper/mybluray /mnt/udf

';
	print $fh $items->{$name}{Script}."\n";

	print $fh
	  'sudo umount /mnt/udf

sudo cryptsetup luksClose /dev/mapper/mybluray

sudo losetup -d "$imgloop"

# sudo growisofs -dvd-compat -Z "$cddevice"="$imgfile"
sudo xorriso -as cdrecord -v dev="$cddevice" "$imgfile"
';
	$fh->close();
      }
    }
  }
}


sub old_visualize {
  my $self = attr shift;
  if (ref $self) {
    foreach my $media (values %{$self->mediastruct->medias}) {
      if ($media->used_space) {
	print $media->used_space . "\t" . $media->type . "\n";
	foreach my $dir (values %{$media->contains}) {
	  print $dir->size . "\t" . $dir->name . "\n";
	}
	print "\n";
      }
    }
  }
}

sub show_queues {
  my $self = attr shift;
  if (ref $self) {
    print "<begin debug>\n";
    foreach my $thing (@{$self->dirqueue}) {
      print ref $thing;
      if (ref $thing) {
	print "\t" . $thing->size . "\t" . $thing->name . "\n";
      }
    }

    print "<begin debug>\n";
    foreach my $thing (@{$self->mediaqueue}) {
      print ref $thing;
      if (ref $thing) {
	print "\t" . $thing->size . "\t" . $thing->type . "\n";
      }
    }
  }
}

1;
