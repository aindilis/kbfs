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
my $class = 1;

my ($fh, $filename) = (undef,"/tmp/kbfs-tracker.CzP5G");
if (1) {
  ($fh, $filename) = tempfile('kbfs-tracker.XXXXX', DIR => '/tmp');
  print $fh rand(1000);
  $fh->close();
}

my $expressions =
  [
   ["test2", KBFS::Util::Var("?_")],
  ];

$tracker->AssertStatements
  (
   Context => 'Org::FRDCSA::KBFS::Tmp',
   Class => $class,
   Filename => $filename,
   Assertions => $expressions,
  );

$UNIVERSAL::now = 1;
my $res1 = $tracker->RetrieveStatements
  (
   Context => 'Org::FRDCSA::KBFS::Tmp',
   Class => $class,
   Filenames => [$filename],
  );
print Dumper({Res1 => $res1});

if (1) {
  my $filename2 = mktemp( '/tmp/kbfs-tracker-2.XXXXX' );
  system 'mv '.shell_quote($filename).' '.shell_quote($filename2);

  my $res2 = $tracker->RetrieveStatements
    (
     Context => 'Org::FRDCSA::KBFS::Tmp',
     Class => $class,
     Filenames => [$filename2],
    );
  print Dumper({Res2 => $res2});
}
