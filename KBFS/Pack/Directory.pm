package KBFS::Pack::Directory;

use strict;

sub new {
  my $that  = shift;
  my $class = ref($that) || $that;
  my $self = {
	      NAME  => undef,
	      SIZE  => undef,
	      PARENT => undef,
	      CHILDREN => [],
	     };
  bless($self, $class);
  my $tmp = shift;
  if ($tmp ne "") {
    $self->name($tmp);
  }
  $tmp = shift;
  if (defined($tmp)) {
    $self->size($tmp);
  }
  return $self;
}

use Alias qw(attr);
our ($NAME, $SIZE, $PARENT, @CHILDREN);

sub name {
  my $self = attr shift;
  if (@_) {
    $NAME = shift;
  }
  return    $NAME;
}

sub size {
  my $self = attr shift;
  if (@_) {
    $SIZE = shift;
  }
  return    $SIZE;
}

sub parent  {
  my $self = attr shift;
  if (@_) {
    $PARENT = shift;
  }
  return    $PARENT;
}

sub children {
  my $self = attr shift;
  if (@_) { 
    foreach my $child (@_) {
      push @CHILDREN, $child;
    }
  }
  return    @CHILDREN;
}

sub add_children {
  my $self = attr shift;
  if (@_) { 
    foreach my $child (@_) {
      push @CHILDREN, $child;
      #print "<>" .  @CHILDREN . "<>\n";
    }
  }
  return    @CHILDREN;
}

sub describe {
  my $self = attr shift;
  if (ref $self) {
    print "<" . $self->name() . ">\n<" . $self->size() . ">\n<" . $self->parent() . ">\n<" . $self->children() . ">\n\n";
  }
}

sub list_all_subdirs {
  my $self = attr shift;
  my @list;
  push @list, $self;
  foreach my $child (@CHILDREN) {
    push @list, $child->list_all_subdirs;
  }
  return @list;
}

sub list_all_parentdirs {
  my $self = attr shift;
  my @list;
  push @list, $self;
  #print "<" . $self->name . ">\n";
  #print "<" . $self->parent . ">\n";
  if (ref $self->parent) {
    push @list, $self->parent->list_all_parentdirs;
  }
  return @list;
}

sub parent_name {
  my $self = attr shift;
  if (ref $self) {
    my $parentname = $self->name;
    $parentname =~ s/^(.*)\/.+?$/$1/;
    return $parentname;
  }
}

1;
