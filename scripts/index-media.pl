#!/usr/bin/perl -w

# program to index and search CD/DVDs

use Manager::Dialog qw(Approve);

use Data::Dumper;

my $datadir = "/var/lib/myfrdcsa/codebases/internal/kbfs/data/index-media";

while (Approve("Index another media?")) {
  print "New media: ".GetID()."\n";
  IndexMedia();
}

sub IndexMedia {
  my $id = GetID();
  # mount the drive
  Do("sudo mount -t iso9660 /dev/cdrom /mnt/cdrom","sleep 10");

  my @files = split /\n/,`sudo find /mnt/cdrom -follow`;
  print "Number of files: ".(scalar @files)."\n";
  # check whether this is identical to another disc
  # not implemented

  # save
  my $OUT;
  open(OUT,">$datadir/$id") and print OUT Dumper(\@files) and close(OUT);
  Do("sudo umount /mnt/cdrom","eject","gzip $datadir/$id");
}

sub GetID {
  my $max = 0;
  foreach my $f (split /\n/,`ls "$datadir"`) {
    $f =~ s/\.gz$//;
    # print "$f\n";
    if ($f > $max) {
      $max = $f;
    }
  }
  return $max + 1;
}

sub Do {
  foreach my $c (@_) {
    print "$c\n";
    system $c;
  }
}
