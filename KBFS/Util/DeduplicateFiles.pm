package KBFS::Util::DeduplicateFiles;

use PerlLib::SwissArmyKnife;

use Data::Dumper;
use Digest::MD5 qw(md5 md5_hex md5_base64);
use File::Stat;

require Exporter;
@ISA = qw(Exporter);
@EXPORT = qw (DetectDuplicateFiles);

sub DetectDuplicateFiles {
  my %args = @_;
  # find files that are the same
  # first sort by size

  my $files = {};
  foreach my $file (@{$args{Files}}) {
    if (-f $file) {
      my $stat = File::Stat->new($file);
      $files->{$file}->{Size} = $stat->size;
    }
  }
  my $sizes = {};
  foreach my $key (keys %$files) {
    my $e = $files->{$key};
    $sizes->{$e->{Size}}->{$key}++;
  }

  my @duplicates;
  foreach my $size (keys %$sizes) {
    print "S: $size\n";
    my $md5sums = {};
    if ((scalar keys %{$sizes->{$size}}) > 1) {
      foreach my $file (keys %{$sizes->{$size}}) {
	print "\tF: $file\n";
	my $md5sum;
	if ($args{Sayer}) {
	  my @res = $args{Sayer}->ExecuteCodeOnData
	    (
	     Data => [{File => $file}],
	     CodeRef => sub {
	       return MD5SumFile
		 (
		  File => $_[0]->{File},
		 );
	     },
	     # Overwrite => 1,
	    );
	  $md5sum = $res[0];
	} else {
	  $md5sum = MD5SumFile(File => $file);
	}
	$md5sums->{$md5sum}->{$file}++;
      }
    }
    foreach my $md5sum (keys %$md5sums) {
      if (scalar keys %{$md5sums->{$md5sum}} > 1) {
	# these are duplicates
	push @duplicates, [keys %{$md5sums->{$md5sum}}];
      }
    }
  }
  return {
	  Success => 1,
	  Duplicates => \@duplicates,
	 };
}

sub MD5SumFile {
  my %args = @_;
  return md5_base64(read_file($args{File}));
}

1;
