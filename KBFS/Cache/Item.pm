package KBFS::Cache::Item;

use PerlLib::SwissArmyKnife;
use XML::Twig;

use strict;
use Carp;
use vars qw($VERSION);

$VERSION = '1.00';

use Class::MethodMaker new_with_init => 'new',
  get_set => [ qw / URI CID MD5 Loc / ];

sub init {
  my ($self,%args) = @_;
  $self->URI($args{URI});
  $self->CID($args{CID}) if exists $args{CID};
  $self->Loc($args{Loc}) if exists $args{Loc};
  $self->MD5($args{MD5} || "");
}

sub HeadOfContents {
  my ($self,%args) = @_;
  my $query = "head -n 10 ".$self->URI;
  my $result = `$query`;
  return $result;
}

sub Contents {
  my ($self,%args) = @_;
  my $query = "cat ".$self->Loc;
  my $result = `$query`;
  return $result;
}

sub GrowTwig {
  my ($self,%args) = @_;
  my $cacheitem = XML::Twig::Elt->new('cacheitem');

  my $uri = XML::Twig::Elt->new('uri');
  $uri->set_text($self->URI);
  $uri->paste('last_child', $cacheitem);

  my $cid = XML::Twig::Elt->new('cid');
  $cid->set_text($self->CID);
  $cid->paste('last_child', $cacheitem);

  my $md5 = XML::Twig::Elt->new('md5');
  $md5->set_text($self->MD5);
  $md5->paste('last_child', $cacheitem);

  my $loc = XML::Twig::Elt->new('loc');
  $loc->set_text($self->Loc);
  $loc->paste('last_child', $cacheitem);

  return $cacheitem;
}

sub Print {
  my ($self,%args) = @_;
  print $self->GrowTwig->print;
}

sub Retrieve {
  my ($self,%args) = @_;
  if ($self->URI =~ /^file:\/\/(.*)/ and
      -f $1) {
    system "cp \"" . $1 . "\" " . $self->Loc;
  } else {
    my $command = "wget -T 6 ".shell_quote($self->URI)." -O ".shell_quote($self->Loc)." >/dev/null 2>/dev/null";
    # print $command."\n";
    system $command;
  }
}

1;
