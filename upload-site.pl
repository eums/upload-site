#!/usr/bin/env perl
use warnings;
use Digest::SHA qw(hmac_sha1_hex);

# Place another file in the same directory as this one called
# upload-site-config.pl, and make sure it assigns the following variables:
#
#   $archive_filename => The filename for the temporary archive.
#   $output_directory => where to put the extracted files
#   $secret => HMAC_SHA1 key for verifying POST data.
require 'upload-site-config.pl';

sub extract
{
  my $archive_filename = $_[0];
  my $destination_dir  = $_[1];

  my @args =
    ("/bin/tar", "-xzf", $archive_filename, "-C", $destination_dir, "--preserve-permissions");
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

sub verify_hmac
{
  my $data          = $_[0];
  my $received_hmac = $_[1];
  my $secret        = $_[2];

  my $hmac = hmac_sha1_hex($data, $secret);
  return constant_time_compare($hmac, $received_hmac);
}

sub constant_time_compare
{
  my $a = $_[0];
  my $b = $_[1];

  if (length($a) != length($b)) {
    return 0;
  }

  my $r = 0;
  my $i = 0;
  while ($i < length($b)) {
    $r |= ord(substr $a, $i, 1) ^ ord(substr $b, $i, 1);
    $i++;
  }

  return ($r == 0);
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

    if (verify_hmac($data, $ENV{'HTTP_X_SIGNATURE'}, $secret)) {
      write_data($archive_filename, $data);
      extract($archive_filename, $output_directory);
      print "\r\ndone\r\n";
    } else {
      print "Status: 400 Bad Request\r\n";
      print "\r\nsignature mismatch\r\n";
    }
  }
}

main()
