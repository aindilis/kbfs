#!/usr/bin/perl -w

use Data::Dumper;

use File::Stat;
use DateTime;
use DateTime::Duration;
use DateTime::Format::Duration;

my $d = DateTime::Format::Duration->new
  (
   pattern => '%Y years, %m months, %e days, '.
   '%H hours, %M minutes, %S seconds'
  );

my $datetime = DateTime->new
  (
   year => 2010,
   month => 1,
   day => 11,
   hour => 19,
   minute => 0,
   second => 0,
   time_zone => "America/Chicago",
  );

my $command;
if (1) {
  $command = "locate .";
} else {
  $command = "find .";
}

my $dates = {};
foreach my $file (split /\n/, `$command`) {
  # print "$file\n";
  my $stat = File::Stat->new($file);
  if (defined $stat->ctime) {
    my $durc = DateTime->from_epoch(epoch => $stat->ctime) - $datetime;
    # my $dura = DateTime->from_epoch(epoch => $stat->atime) - $datetime;
    # my $durm = DateTime->from_epoch(epoch => $stat->mtime) - $datetime;
    $dates->{$file} = $durc;
    # $dates->{$dura}->{$file}++;
    # $dates->{$durm}->{$file}++;
  }
}

foreach my $file (sort {DateTime::Duration->compare($dates->{$a}, $dates->{$b}, $datetime)} keys %$dates) {
  print $d->format_duration($dates->{$file})."\t".$file."\n";
}

# build and save an index
