#!/usr/bin/env perl
use strict;
use warnings;

use CGI;

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

sub write_from_stdin
{
  my $archive_filename = $_[0];

  open(my $fh, '>', $archive_filename)
    or die "could not open $archive_filename";

  while (<>) {
    print $fh $_;
  }

  close($fh);
}

sub main
{
  my $cgi = new CGI;

  if ($cgi->request_method() ne 'POST') {
    print $cgi->header('text/html', '405 Method Not Allowed');
    print 'Method not allowed';
  } else {
    write_from_stdin($archive_filename);
    extract($archive_filename, $output_directory);
    print $cgi->header('text/html');
  }
}

main
