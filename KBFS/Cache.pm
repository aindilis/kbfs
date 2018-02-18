package KBFS::Cache;

use KBFS::Cache::Item;

use Data::Dumper;

use XML::Twig;
use String::Random;

use strict;
use Carp;
use vars qw($VERSION);

$VERSION = '1.00';

use Class::MethodMaker new_with_init => 'new',
  get_set => [ qw / Random MetadataFile CacheDir CacheType Contents Count
                    MD5Hash URIHash / ];

sub init {
  my ($self,%args) = (shift,@_);
  $self->CacheDir($args{CacheDir});
  $self->CacheType($args{CacheType});
  $self->Random(String::Random->new);
  $self->Count(0);
  $self->URIHash({});
  $self->Contents({});
  if (! -d $self->CacheDir) {
    if (-f $self->CacheDir) {
      die "Cannot make cache dir: ".$self->CacheDir."\n";
    } else {
      system "mkdirhier ".$self->CacheDir or
	die "Cannot make cache dir: ".$self->CacheDir."\n";
    }
  }
  $self->MetadataFile($args{CacheDir}."/.metadata");
  if (-f $self->MetadataFile) {
    print "Importing metadata file <".$self->MetadataFile.">...\n";
    $self->ImportMetadata;
  } else {
    # no metadata, must populate the cache eventually, but not a problem right now.
  }
  # since we've loaded it, hash all the md5s
  my %mash;
  foreach my $item ($self->ListContents) {
    $mash{$item->MD5} = $item;
    $self->URIHash->{$item->URI} = $item;
    print Dumper
      ({
	MD5 => $item->MD5,
	URI => $item->URI,
       });
  }
  $self->MD5Hash(\%mash);
}

sub Contains {
  my ($self,$uri) = (shift,shift);
  return $self->URIHash->{$uri};
}

sub CacheNewItem {
  my ($self,%args) = (shift,@_);
  my $uri = $args{URI};

  # check that it doesn't already exist in the cache
  my $check = $self->Contains($uri);
  if (! defined $check) {
    # if the uri exists, cache it
    my $item = $self->AddItem
      (
       Item => KBFS::Cache::Item->new
       (
	URI => $uri,
	CID => $self->NewCID,
       ),
      );
    $item->Loc($self->CacheDir . "/" . $item->CID);
    $item->MD5($self->MD5SumFile($item->URI));
    # then retrieve and make searchable all of its properties
    if ($self->CacheType eq "web") {
      if ($args{Content}) {
	my $OUT;
	open $OUT, ">".$item->Loc or die "cannot open item";
	print OUT $args{Content};
	close OUT;
      } elsif (! $args{DoNotRetrieve}) {
	$item->Retrieve;
      }
    } elsif ($self->CacheType eq "original") {
      system "ln -s \"" . $item->URI . "\" " . $item->Loc;
    } elsif ($self->CacheType eq "copy") {
      system "cp \"" . $item->URI . "\" " . $item->Loc;
    }
    return $item;
  } else {
    return $check;
    #print "Item <$uri> already exists in cache.\n";
    #my $item = $self->AddItem(Item => $check);
  }
}

sub Cache {
  my ($self,%args) = (shift,@_);
  my $item = $args{Item};
  my $check = $self->Contains($item->URI);
  if (! $check) {
    # if the uri exists, cache it
    if (! defined $item->CID) {
      $item->CID($self->NewCID);
    }
    $self->AddItem(Item => $item);
    $item->Loc($self->CacheDir . "/" . $item->CID);
    $item->MD5($self->MD5SumFile($item->URI));
    # then retrieve and make searchable all of its properties
    if ($self->CacheType eq "web") {
      if ($args{Content}) {
	my $OUT;
	open $OUT, ">".$item->Loc or die "cannot open item";
	print OUT $args{Content};
	close OUT;
      } else {
	my $c = "wget -T 10 \"" . $item->URI . "\" -O " . $item->Loc;
	print "$c\n";
	system $c;
      }
    } elsif ($self->CacheType eq "original") {
      system "ln -s \"" . $item->URI . "\" " . $item->Loc;
    } elsif ($self->CacheType eq "copy") {
      system "cp \"" . $item->URI . "\" " . $item->Loc;
    }
    return $item;
  } else {
    return $check;
    #print "Item <$uri> already exists in cache.\n";
    #my $item = $self->AddItem(Item => $check);
  }
}

sub LookupMD5 {
  my ($self,$md5) = (shift,shift);
#   foreach my $item ($self->ListContents) {
#     if ($item->MD5 eq $md5) {
#       return $item;
#     }
#   }
  if (exists $self->MD5Hash->{$md5}) {
    return $self->MD5Hash->{$md5};
  }
  return;
}

sub MD5SumFile {
  my ($self,$file) = (shift,shift);
  return "";
  if (-f $file) {
    my $md5 = `md5sum \"$file\"`;
    $md5 =~ s/^(\w+).*/$1/;
    chomp $md5;
    return $md5;
  }
  return "";
}

sub AddItem {
  my ($self,%args) = (shift,@_);
  $self->URIHash->{$args{Item}->URI} = $args{Item};
  $self->Contents->{$args{Item}->CID} = $args{Item};
  $self->Count($self->Count + 1);
  return $args{Item};
}

sub ListContents {
  my ($self,%args) = (shift,@_);
  return values %{$self->Contents};
}

sub ExportMetadata {
  my ($self,%args) = (shift,@_);
  my $t = XML::Twig->new(pretty_print => 'indented');
  # index cache metadata

  my $cache = XML::Twig::Elt->new('cache');

  my $metadatafile = XML::Twig::Elt->new('metadatafile');
  $metadatafile->set_text($self->MetadataFile);
  $metadatafile->paste('last_child', $cache);

  my $cachedir = XML::Twig::Elt->new('cachedir');
  $cachedir->set_text($self->CacheDir);
  $cachedir->paste('last_child', $cache);

  my $cachetype = XML::Twig::Elt->new('cachetype');
  $cachetype->set_text($self->CacheType);
  $cachetype->paste('last_child', $cache);

  my $count = XML::Twig::Elt->new('count');
  $count->set_text($self->Count);
  $count->paste('last_child', $cache);

  my $contents = XML::Twig::Elt->new('contents');
  $contents->paste('last_child', $cache);

  # index item metadata
  foreach my $item ($self->ListContents) {
    my $cacheitem = $item->GrowTwig;
    $cacheitem->paste('last_child', $contents);
  }
  $self->WriteMetadataFile(Cache => $cache);
}

sub WriteMetadataFile {
  my ($self,%args) = (shift,@_);
  my $FILE = 1;
  open(FILE, ">".$self->MetadataFile) or
    croak "Cannot open metadata file: ".$self->MetadataFile."\n";
  $args{Cache}->print( \*FILE);
  close FILE;
}

sub ImportMetadata {
  my ($self, %args) = (shift,@_);
  my $t = XML::Twig->new(pretty_print => 'indented',
			 twig_handlers =>
			 {
			  cacheitem   => sub { $self->ImportCacheItem($_) }
			 });
  $t->parsefile($self->MetadataFile);
  my $cache = $t->root;
  $cache->set_gi('cache');
  $self->MetadataFile($cache->first_child('metadatafile')->text);
  $self->CacheDir($cache->first_child('cachedir')->text);
  $self->CacheType($cache->first_child('cachetype')->text);
  $self->Count($cache->first_child('count')->text);
}

sub ImportCacheItem {
  my ($self, $cacheitem) = (shift,@_);
  my $cid = $cacheitem->first_child('cid')->text;
  if ($self->ExistsCID($cid)) {
    # already taken, do not bother to create a new one
    print "Already taken, do not bother to create a new one.\n";
    print "Old: $cid\n";
  } else {
    print "New: $cid\n";
    my $item = KBFS::Cache::Item->new
      (URI => $cacheitem->first_child('uri')->text,
       CID => $cid,
       MD5 => $cacheitem->first_child('md5')->text,
       Loc => $cacheitem->first_child('loc')->text);
    $self->AddItem(Item => $item);
  }
}

sub ExistsCID {
  my ($self,$cid) = (shift,shift);
  return exists $self->Contents->{$cid};
}

sub NewCID {
  my ($self,%args) = (shift,@_);
  my $CID;
  do {
    $CID = $self->Random->randregex('[A-Za-z0-9]{16}')
  } while ($self->ExistsCID($CID));
  return $CID;
}

1;

__END__

=pod

=head1 NAME

KBFS::Cache -- File system based persistent cache for files and URI

=head1 DESCRIPTION

Allows the user to cache various objects.

=head1 SYNOPSIS

  use KBFS::Cache;

    $self->Cache
      (KBFS::Cache->new
       (CacheType => $args{CacheType} || "original",
	CacheDir => $args{CacheDir} || "data/$archive/mycache"));

    if (! $self->Cache->ListContents) {
      $self->Cache->ExportMetadata;
    }

    if (! $self->Cache->Contains($file)) {
	print "New File: $file\n";
	$self->Cache->CacheNewItem(URI => $file);
    }

    my $cacheitem = $self->ItemtoCacheItem($item);
    print "<<<$cacheitem>>>\n";
    print $cacheitem->CID."\n";
    $items->{$cacheitem->CID} =
	Critic::Item->new
            (CID => $cacheitem->CID);

=head1 METHODS

ItemToCacheItem

=over

=item B<Clear( [$cache_root] )>

See Cache::Cache, with the optional I<$cache_root> parameter.

=item B<Purge( [$cache_root] )>

See Cache::Cache, with the optional I<$cache_root> parameter.

=item B<Size( [$cache_root] )>

See Cache::Cache, with the optional I<$cache_root> parameter.

=back

=head1 OPTIONS

See Cache::Cache for standard options.  Additionally, options are set
by passing in a reference to a hash containing any of the following
keys:

=over

=item I<cache_root>

The location in the filesystem that will hold the root of the cache.
Defaults to the 'FileCache' under the OS default temp directory (
often '/tmp' on UNIXes ) unless explicitly set.

=item I<cache_depth>

The number of subdirectories deep to cache object item.  This should
be large enough that no cache directory has more than a few hundred
objects.  Defaults to 3 unless explicitly set.

=item I<directory_umask>

The directories in the cache on the filesystem should be globally
writable to allow for multiple users.  While this is a potential
security concern, the actual cache entries are written with the user's
umask, thus reducing the risk of cache poisoning.  If you desire it to
only be user writable, set the 'directory_umask' option to '077' or
similar.  Defaults to '000' unless explicitly set.

=back

=head1 PROPERTIES

See Cache::Cache for default properties.

=over

=item B<(get|set)_cache_root>

See the definition above for the option I<cache_root>

=item B<(get|set)_cache_depth>

See the definition above for the option I<cache_depth>

=item B<(get|set)_directory_umask>

See the definition above for the option I<directory_umask>

=back

=head1 SEE ALSO

Cache::Cache

=head1 AUTHOR

Original author: DeWitt Clinton <dewitt@unto.net>

Last author:     $Author: dclinton $

Copyright (C) 2001-2003 DeWitt Clinton

=cut
