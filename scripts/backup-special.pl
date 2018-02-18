#!/usr/bin/perl -w

use Manager::Dialog qw(ApproveCommands);

# find all files of importance, interest for backing up
# get latest versions of systems

my @args;
foreach my $f (split /\n/,`ls -l /var/lib/myfrdcsa/codebases/internal/`) {
  if ($f =~ / -> (.*)$/) {
    my $f2 = $1;
    if (-d $f2) {
      push @args, "$f2=$f2";
    }
  }
}

my $isofile = "/mnt/hda3/temp.iso";

ApproveCommands
  (Method => 'serial',
   Commands =>
   ["sudo /sbin/modprobe ide-scsi",
    "mkisofs -o $isofile -r -graft-points ".join(" ",@args),
    "dvdrecord dev=0,0,0 -dao $isofile"]);

