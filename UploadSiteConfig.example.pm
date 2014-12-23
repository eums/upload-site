#!/usr/bin/env perl

package UploadSiteConfig;

use strict;
use warnings;

our $secret = "super secret key";
our $archive_filename = "/tmp/upload-site-archive.tar.gz";
our $output_directory = "/var/www/html";

1;
