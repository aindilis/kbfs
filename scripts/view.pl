#!/usr/bin/perl -w

# gnome-view???

sub View {
  my %args = @_;
  foreach my $file (@{$args{Files}}) {
    print "$file\n";
    if (-f $file) {
      if ($file =~ /\.html?$/i) {
	my $c = "mozilla -remote 'openFILE(file:///home/jasayne/ftp.dougherty.org.uk/$file,new-tab)'";
	print "$c\n";
	system $c;
      } elsif ($file =~ /\.pdf$/i) {
	system "acroread \"$file\"";
      } elsif ($file =~ /\.(jpe?g|gif)$/i) {
	system "xview \"$file\"";
      } else {
	print "CANT OPEN\n";
      }
    } else {
      print "FILE NOT FOUND\n";
    }
  }
}

View
  (Files => \@ARGV);
