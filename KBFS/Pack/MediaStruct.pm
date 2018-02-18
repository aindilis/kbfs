package KBFS::Pack::MediaStruct;
use strict;
use KBFS::Pack::Media;

sub new {
    my $that  = shift;
    my $class = ref($that) || $that;
    my $self = {
	MEDIAS => {},
	LARGESTMEDIA => undef,
    };
    bless($self, $class);

    my $tmp = shift;
    $self->index_media($tmp);
    return $self;
}

use Alias qw(attr);
our (%MEDIAS, $LARGESTMEDIA);

sub index_media {
  my $self = attr shift;
  if (ref $self) {
    my $media = shift;
    my %MediaSize = (
		     "BD-R" => 22250000,
		     "DVD-R" => 4700000,
		     "CD-RW" => 700000,
		    );
    foreach my $type (keys %$media) {
      foreach (1..($media->{$type})) {
	my $newmedia = KBFS::Pack::Media->new($type,$MediaSize{$type});
	$self->add_media($newmedia);
      }
    }
  }
}

sub medias {
    my $self = attr shift;
    if (@_) { 
	my $it = shift;
	%MEDIAS = %{$it}
    }
    return    \%MEDIAS;
}

sub largestmedia {
    my $self = attr shift;
    if (@_) { $LARGESTMEDIA = shift; }
    return    $LARGESTMEDIA;
}

sub largestmediasize {
    my $self = attr shift;
    if (ref $self->largestmedia) {
	return $self->largestmedia->size;
    } else {
	return    0;
    }
}

sub add_media {
    my $self = attr shift;
    if (@_) {
	foreach my $ref (@_) {
	    $MEDIAS{$ref} = $ref;
	    if ($ref->size >= $self->largestmediasize) {
		$self->largestmedia($ref);
	    }
	}
    }
}


1;
