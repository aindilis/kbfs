#!/usr/bin/perl -w

use Data::Dumper;

my $duks = `du -k /var/lib/myfrdcsas 2> /dev/null | tail -n 10`;
my @lines = split(/\n/, $duks);
print Dumper(\@lines);
