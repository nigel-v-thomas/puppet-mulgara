class mulgara::service (
  $home_dir = $mulgara::params::home_dir,
  $data_dir = $mulgara::params::data_dir,
  $log_dir = $mulgara::params::log_dir,
  $mulgara_user = $mulgara::params::mulgara_user,
  ) inherits mulgara::params {
 
  $mulgara_full_path = "${home_dir}/mulgara.jar"
  $mulgara_base_dir = "${home_dir}/"
  $mulgara_initd_log_dir = "${log_dir}"  
  $mulgara_launch_cmd = "java -jar mulgara.jar -p 8088 -u 8089 -s fedora -k localhost"  
  $mulgara_shutdown_cmd = "java -jar mulgara.jar -x"  

  file { "/etc/init.d/mulgara":
    content => template("mulgara/mulgara-init.d.erb"),
    owner   => $mulgara_user,
    mode    => 0755,
  }
  
  service{ "mulgara":
    ensure => running,
    require => File["/etc/init.d/mulgara"]
  }
}
