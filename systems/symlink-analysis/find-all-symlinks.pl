#!/usr/bin/perl -w

# find: The -H, -L and -P options control the treatment of symbolic
# links.

# doesn't seem to be able to do it, need ls -R

my $hostname = `hostname -f`;
chomp $hostname;
my $fn = "$hostname.ls-alR.txt";
if (! -f $fn) {
  system "ls -alR / > $fn";
}

# now process this output

# have in perllib a default set of output processors for different
# programs
