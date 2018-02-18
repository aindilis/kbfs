#!/usr/bin/perl -w

# suppose you have  a decimated filesystem A and  an earlier backup B,
# and you want to locate potentially new files (in A \ B).

my $pathtoA = "/mnt/hdb4/var/lib/myfrdcsa";
my $pathtoB = "/var/lib/myfrdcsa";

# obtain all the stats for A and B, and then look for new files

# save the information so we don't have to rerun the scan
