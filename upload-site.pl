#!/usr/bin/env perl
use strict;
use warnings;

use autodie;
use IO::File;
use CGI qw/:standard/;

my $archive_filename = "/tmp/upload-site-archive.tar.gz";
my $output_directory = "/tmp/upload-site-output";

sub extract
{
  my $archive_filename = $_[0];
  my $destination_dir  = $_[1];

  my @args =
    ("/bin/tar", "-xzf", $archive_filename, "-C", $destination_dir, ".");
  system(@args) == 0
    or die "extraction failed with code: $?";
}

sub write_file
{
  my $archive_filename = $_[0];
  my $data             = $_[1];

  my $fh = IO::File->new($archive_filename, 'w');
  print $fh $data;
  undef $fh;
}

sub main
{
  my $cgi = new CGI;

  if ($cgi->request_method() != 'POST') {
    print $cgi->header('text/html', '405 Method Not Allowed');
  }

  write_file($archive_filename, $cgi->param('POSTDATA'));
  extract($archive_filename, $output_directory);
}

main
