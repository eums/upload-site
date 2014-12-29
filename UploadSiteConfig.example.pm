#!/usr/bin/env perl

package UploadSiteConfig;

use strict;
use warnings;

# HMAC key used for verifying uploaded data
our $secret = "super secret key";

# The directory to extract the site to
our $output_directory = "/var/www/html";

# The filename to use for the temporary file to save the archive data to,
# before extracting it
our $archive_filename = "/tmp/UploadSite/archive.tar.gz";

# A temporary directory to extract the site to before replacing the old one
our $extract_directory = "/tmp/UploadSite/extracted";

1;
