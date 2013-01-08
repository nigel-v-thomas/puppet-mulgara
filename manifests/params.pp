# This is the generic solr parameters
class mulgara::params {
  case $operatingsystem {
    /(Ubuntu|Debian)/: {
      $source_url = "/vagrant/mulgara-2.1.13-bin.tar.gz"
      $home_dir = "/usr/share/mulgara-2.1.13/"
      $data_dir = "/var/lib/mulgara/"
      $log_dir = "/var/log/mulgara/"
      $package = "mulgara-2.1.13"
      $mulgara_user_home_dir = "/home/mulgara36"
      $mulgara_user = "mulgara36"
      $java_home = "/usr/lib/jvm/java-6-openjdk-amd64/"
      $enable_resource_index = true
      $create_mulgara_user = true
    }
    default: {
      fail("Operating system $operatingsystem is not supported by the tomcat module")
    }
  }
}
