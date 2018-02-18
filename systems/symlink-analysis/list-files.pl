#!/usr/bin/perl -w

use PerlLib::SwissArmyKnife;

my $data = read_file('justin.frdcsa.org.ls-alR.txt');

my $results = {};
my $dir;
my $state = 'directory';
foreach my $line (split /\n/, $data) {
  if ($state eq 'directory') {
    if ($line =~ /^(.+?):/) {
      $dir = $1;
    } else {
      die "error $line\n";
    }
    $state = 'total';
  } elsif ($state eq 'total') {
    $state = 'files';
  } elsif ($state eq 'files') {
    if ($line eq '') {
      $state = 'directory';
    } else {
      #               drwxr-xr-x  27 root    root    4096    Jan     27      03:54
      #               crw-rw----+  1 root    audio   14, 12  Jan     26 16:40 adsp
      if ($line =~ /^(\S+)\s+(\d+)\s+(\S+)\s+(\S+)\s+(\d+|\d+,\s+\d+)\s+(\w+)\s+(\d+)\s+([0-9:]+)\s+(.+?)$/) {
	my $date = $8;
	# print $dir.'/'.$9."\n";
	if ($date !~ /:/) {
	  $results->{$date}++;
	}

      } else {
	die "cannot parse $line\n";
      }
    }
  }
}

print Dumper($results);
