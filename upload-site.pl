#!/usr/bin/env perl

use IO::Zlib;
use Archive::Tar;
use CGI;
use Cwd;

sub extract
{
  my ($archive_filename, $destination) = @_;

  my $zlib = IO::Zlib->new($archive_filename, 'r');
  my $tar = Archive::Tar->new;

  my $cwd = getcwd;
  chdir($destination);
  $tar->read($zlib, {extract => 'true'});
  chdir($cwd);
}

extract("archive.tar.gz", "./dest");
