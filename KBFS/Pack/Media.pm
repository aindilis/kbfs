package KBFS::Pack::Media;
use strict;

sub new {
    my $that  = shift;
    my $class = ref($that) || $that;
    my $self = {
	TYPE => undef,
	SIZE => undef,
	USED_SPACE => undef,
	CONTAINS => {},
    };
    bless($self, $class);
    my $tmp = shift;
    if (defined($tmp)) {
	$self->type($tmp);
    }
    $tmp = shift;
    if (defined($tmp)) {
	$self->size($tmp);
    }
    $tmp = shift;
    if (defined($tmp)) {
	$self->used_space($tmp);
    } else {
	$self->used_space(0);
    }
    $tmp = shift;
    if (defined($tmp)) {
	$self->contains($tmp);
    }
    return $self;
}

use Alias qw(attr);
our ($TYPE,$SIZE,$USED_SPACE,%CONTAINS);

sub type {
    my $self = attr shift;
    if (@_) { $TYPE = shift; }
    return    $TYPE;
}

sub size {
    my $self = attr shift;
    if (@_) { $SIZE = shift; }
    return    $SIZE;
}

sub used_space {
    my $self = attr shift;
    if (@_) { $USED_SPACE = shift; }
    return    $USED_SPACE;
}

sub free_space {
    my $self = attr shift;
    return $self->size - $self->used_space;
}

sub contains {
    my $self = attr shift;
    if (@_) { 
	my $it = shift;
	%CONTAINS = %{$it}
    }
    return    \%CONTAINS;
}

sub add_file {
    my $self = attr shift;
    if (@_) {
	my $file = shift;
	if ($self->size >= $self->used_space + $file->size) {
	    if (!defined($CONTAINS{$file})) {
		$CONTAINS{$file} = $file;
		$self->used_space($self->used_space + $file->size);
		print $file->size . "\t" . $file->name . "\n";
		print $self->free_space . "\t/\t" . $self->size . "\n";
		return 0;
	    }
	} 
    }
    return 1;	    
}

1;
