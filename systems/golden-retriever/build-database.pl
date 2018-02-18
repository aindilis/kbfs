#!/usr/bin/perl -w

use PerlLib::MySQL;

use Data::Dumper;
use DateTime;
use DateTime::Duration;
use DateTime::Format::Duration;
use File::Basename;
use File::Slurp;
use File::Stat;
use Term::ProgressBar;

my $itemtoid = {};

my $mysql = PerlLib::MySQL->new
  (
   DBName => "golden_retriever",
   # Debug => 1,
  );

my $progress;
my $totalitems = -3;

sub LoadFileList {
  my $locatefile = "locate.txt";
  my $quotedlocatefile = "'locate.txt'";
  if (! -f $locatefile) {
    system "locate / > $quotedlocatedfile";
  }
  my $c = read_file($locatefile);
  my @items = split /\n/, $c;
  $totalitems = scalar @items;
  $progress = Term::ProgressBar->new
    ({count => $totalitems});
  my $cnt = 0;
  foreach my $item (@items) {
    my $res = AddItem
      (
       Item => $item,
      );
    if ($res->{Success}) {
      print Dumper({Result => $res->{Result}})."\n" if $debug;
    }
    # sleep 1;
    ++$cnt;
    if (!($cnt % 1000)) {
      $progress->update($cnt);
    }
  }
}

sub AddItem {
  my %args = @_;
  print $args{Item}."\n" if $debug;
  print Dumper($itemtoid) if $debug;
  my @list;
  my $id = -2;
  if ($args{Item} ne "/") {
    # attempt to find the parent directories
    if (exists $itemtoid->{$args{Item}}) {
      return {
	      Success => 1,
	      Result => $itemtoid->{$args{Item}},
	      List => \@list,
	     };
    } else {
      my $res = AddItem
	(
	 Item => dirname($args{Item}),
	);
      print Dumper($res) if $debug;
      my $parentid = -1;
      if ($res->{Success}) {
	$parentid = $res->{Result};
	push @list, @{$res->{List}};
      }
      my $head = basename($args{Item});
      push @list, $head;
      # now we may insert the new one
      my $stat = File::Stat->new($args{Item});
      if (defined $stat->ctime or defined $stat->atime or defined $stat->mtime) {
	my $ct = $stat->ctime;
	my $at = $stat->atime;
	my $mt = $stat->mtime;
	$mysql->Insert
	  (
	   Table => "items",
	   Values => [
		      undef,
		      $head,
		      $parentid,
		      "from_unixtime($ct)",
		      "from_unixtime($at)",
		      "from_unixtime($mt)",
		     ],
	  );
	$id = $mysql->InsertID;
	$itemtoid->{$args{Item}} = $id;
      }
    }
    return {
	    Success => 1,
	    Result => $id,
	    List => \@list,
	   };
  }
  return {
	  Success => 0,
	 };
}

# db schema

# items
# id, name, parent_id, ctime, atime, mtime

LoadFileList();
