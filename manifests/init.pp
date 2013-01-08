# Class: mulgara
#
# This module installs and manages mulgara commons
# Module puppet-mulgara https://github.com/nigel-v-thomas/puppet-mulgara-commons.git
# Parameters:
#
# Actions:
#
# Requires:
#   Package Java JDK
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class mulgara (
      $source_url = $mulgara::params::source_url,
      $home_dir = $mulgara::params::home_dir,
      $data_dir = $mulgara::params::data_dir,
      $log_dir = $mulgara::params::log_dir,
      $package = $mulgara::params::package,
      $mulgara_user = $mulgara::params::mulgara_user,
      $mulgara_user_home_dir = $mulgara::params::mulgara_user_home_dir,
      $java_home = $mulgara::params::java_home,
      $enable_resource_index = $mulgara::params::enable_resource_index,
      $create_mulgara_user = $mulgara::params::create_mulgara_user
      )inherits mulgara::params {

  class { 
    "mulgara::install":
    source_url => $source_url,
    home_dir => $home_dir,
    data_dir => $data_dir,
    log_dir => $log_dir,
    package => $package,
    mulgara_user => $mulgara_user,
    create_mulgara_user => $create_mulgara_user,
    java_home => $java_home,
    mulgara_user_home_dir => $mulgara_user_home_dir
  }

  class {
    "mulgara::service":
    home_dir => $home_dir,
    log_dir => $log_dir,
    package => $package,
    mulgara_user => $mulgara_user,
    require => Class["mulgara::install"]
  }  
}
