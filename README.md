upload-site
===========

Deploys a static site by receiving a tar.gz archive of all its content via HTTP POST.

## Configuration

Edit `UploadSiteConfig.example.pm`, and save it as `UploadSiteConfig.pm` in the
same directory as `UploadSite.pl`.

Make sure you deny access to the configuration files with something like this
(for Apache):

    <Files UploadSiteConfig.pm>
      Order allow,deny
      Deny from all
    </Files>

## Usage

Send a POST request pointing to this script with:

* a gzipped tar archive of all the files in your static site as the request
  body,
* an HMAC-SHA1 authentication code for the archive, using the same secret key
  as in your configuration data, as the `X-Signature` header.

The script simply verifies the data using the authentication code, and if
verified, extracts it to the specified directory.
