package KBFS::Pack::DirectoryTree;

use strict;
use KBFS::Pack::Directory;

use Data::Dumper;

sub new {
  my $that  = shift;
  my $class = ref($that) || $that;
  my $self = {
	      DIRECTORIES  => [],
	      ALL_DIRECTORIES => {},
	     };
  bless($self, $class);
  my $tmp = shift;
  $self->directories($tmp);
  return $self;
}

use Alias qw(attr);
our (@DIRECTORIES,%ALL_DIRECTORIES);

sub directories {
  my $self = attr shift;
  if (@_) { 
    my $it = shift;
    @DIRECTORIES = @{$it};
  }
  return    @DIRECTORIES;
}

sub all_directories {
  my $self = attr shift;
  if (@_) { 
    my $it = shift;
    %ALL_DIRECTORIES = %{$it}
  }
  return    \%ALL_DIRECTORIES;
}

sub index_dirs {
  my $self = attr shift;
  if (ref $self) {
    foreach my $dir ($self->directories) {
      $dir =~ s/\/$//;
      my $duks = `du -k $dir 2> /dev/null`;
      foreach my $line (split /\n/, $duks) {
	my ($directory,$parentdir);
	$line =~ /^([0-9]+)\s+(.*)$/;
	$directory = $self->exists_directory_by_name("$2");
	if (!$directory) {
	  $directory = KBFS::Pack::Directory->new("$2",$1);
	  $self->add_directories($directory);
	}
	$directory->size($1);
	my $it = $directory->parent_name;
	$parentdir = $self->exists_directory_by_name("$it");
	if (!$parentdir) {
	  $parentdir = KBFS::Pack::Directory->new($directory->parent_name);
	  $self->add_directories($parentdir);
	}
	$parentdir->add_children($directory);
	$directory->parent($parentdir);
      }
    }
    $self->remove_dirs_with_undefined_size;
  }
}

sub exists_directory_by_name {
  my $self = attr shift;
  my $it = shift;
  if (defined($ALL_DIRECTORIES{"$it"})) {
    return $ALL_DIRECTORIES{"$it"};
  } else {
    return 0;
  }
}

sub add_directories {
  my $self = attr shift;
  my $ref = shift;
  if (ref $ref) {
    my $it = $ref->name;
    $ALL_DIRECTORIES{"$it"} = $ref;
  } else {
    print "error <" .$ref . ">\n";
  }
}

sub remove_dirs_with_undefined_size {
  my $self = attr shift;
  my %remaining_dirs;
  # remove undefined size dirs
  foreach my $dir (values %{$self->all_directories}) {
    if (defined($dir->size)) {
      $remaining_dirs{$dir->name} = $dir;
    } else {
      print 'Dir has undefined size: <'.$dir->name.">\n";
    }
  }
  $self->all_directories(\%remaining_dirs);
}

1;
