puppet-mulgara
=================

A [puppet module](http://docs.puppetlabs.com) to setup [mulgara](http://www.mulgara.org/), tested on Ubuntu 12.04

Features
========
 * Installs mulgara into a configurable home directory /usr/share/mulgara by default
 * Index and data persisted at /var/lib/mulgara by default based on file system hierarchy guidelines
 * Run as a particular user, with option to create the required user (default behaviour: creates a user mulgara36 and runs as this user)
 * Includes a init.d script to run mulgara as a service - launches mulgara automatically on server start

Setup vagrant
==============

Follow instructions to download and install vagrant from http://vagrantup.com/v1/docs/getting-started/index.html
Configure vagrant to use puppet..
Add this to the modules directory.

Usage
=====
  Define mulgara installation path
      $mulgara_home_path = "/usr/share/mulgara-2.1.13/" 
  
  Set the source url for the installer, this can be a local path or a url to the installer.

      class {"mulgara":
		source_url => "/vagrant/mulgara-2.1.13-bin.tar.gz",
		#source_url => "http://mulgara.org/files/v2.1.13/mulgara-2.1.13-bin.tar.gz",
		home_dir => $mulgara_home_path,
		enable_resource_index => false,
		#create_mulgara_user => false,
		#mulgara_user => "root",
		#mulgara_user_home_dir => "/root/",
      }

  A copy of install properties is kept in the templates files, customise this for your own install.

TODO
====
 * Share with mulgara peeps! 
