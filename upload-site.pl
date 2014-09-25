#!/usr/bin/env perl

sub extract
{
  my $archive_filename = $_[0];
  my $destination_dir  = $_[1];

  @args = ("/bin/tar", "-xzf", $archive_filename, "-C", $destination_dir, ".");
  system(@args) == 0
    or die "extraction failed with code: $?";
}

extract("./archive.tar.gz", "./dest");
