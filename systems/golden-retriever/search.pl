#!/usr/bin/perl -w

# find the closest items to

use PerlLib::MySQL;

use Data::Dumper;
use String::ShellQuote;

my $mysql = PerlLib::MySQL->new
  (
   DBName => "golden_retriever",
  );


my $time = shift || "ctime";
my $keyword = shift || "content";

my $items = $mysql->Do
  (
   Statement => "select id,abs(timestampdiff(SECOND,\"2010-01-11 19:00:00\", $time)),$time from items order by abs(timestampdiff(SECOND,\"2010-01-11 19:00:00\", $time)) asc limit 1000",
   Array => 1,
  );

my @greplist;
foreach my $ref (@$items) {
  if (defined $ref->[1]) {
    # get the filename for this
    my $res = RetrieveItem(ID => $ref->[0]);
    if ($res->{Success}) {
      my $filename = "/".join("/",@{$res->{List}});
      print $ref->[2]."\t".$ref->[1]."\t".$filename."\n";
      push @greplist, $filename;
    } else {
      print "ERROR\n";
    }
  }
}
exit(0);
my $command = "grep -i $keyword ".join(" ",map {shell_quote($_)} @greplist);
# print $command."\n";
system $command;

sub RetrieveItem {
  my %args = @_;
  my $id = $args{ID};
  my @list;
  my $res = $mysql->Do
    (
     Statement => "select name,parent_id from items where id=$id",
     Array => 1,
    );
  if (scalar @$res) {
    my $name = $res->[0]->[0];
    my $parentid = $res->[0]->[1];
    if ($parentid == -1) {
      push @list, $name;
    } else {
      my $res = RetrieveItem
	(
	 ID => $parentid,
	);
      if ($res->{Success}) {
	push @list, @{$res->{List}};
	push @list, $name;
      }
    }
    return {
	    Success => 1,
	    List => \@list,
	   };
  } else {
    return {
	    Success => 0,
	   };
  }
}
