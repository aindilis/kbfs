#!/usr/bin/perl -w

use KBFS::Tracker;
use PerlLib::SwissArmyKnife;

use File::Temp;

# create a new file with a random content, of random length

# assert some class theorems about it

# query the file for these theorems

# move the file to a different directory

# query the file and verify the theorems are the same

# do inference based on the theorems and test that that works

my $tracker = KBFS::Tracker->new();

my ($fh, $filename) = tempfile('kbfs-tracker.XXXXX', DIR => '/tmp');

print $fh rand(1000);
$fh->close();

my $expressions =
  [
   ["this is a test", "test2"],
  ];

$tracker->AssertStatements
  (
   Class => 1,
   Filename => $filename,
   Assertions => $expressions,
   Context => 'Org::FRDCSA::KBFS::Tmp',
  );

my $filename2 = mktemp( '/tmp/kbfs-tracker-2.XXXXX' );

system 'mv '.shell_quote($filename).' '.shell_quote($filename2);

my $res = $tracker->RetrieveStatements
  (
   Filenames => [$filename2],
  );
print Dumper({Res => $res});
