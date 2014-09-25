#!/usr/bin/env perl
use strict;
use warnings;

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

sub write_data
{
  my $filename = $_[0];
  my $data     = $_[1];

  open(my $fh, '>', $filename)
    or die "could not open $filename";

  print $fh $data;

  close($fh);
}

sub main
{
  print "Content-Type: text/plain\r\n";
  if ($ENV{'REQUEST_METHOD'} ne 'POST') {
    print "Status: 405 Method Not Allowed\r\n";
    print "\r\n";
    print "Method not allowed\r\n";
  } else {
    my $data = "";
    read STDIN, $data, $ENV{'CONTENT_LENGTH'};
    write_data($archive_filename, $data);
    extract($archive_filename, $output_directory);
    print "\r\ndone\r\n";
  }
}

main
