class mulgara::service (
  $home_dir,
  $log_dir,
  $package,
  $mulgara_user = $mulgara::params::mulgara_user,
  ) {
 
  $mulgara_base_dir = "${home_dir}/dist/"
  $mulgara_full_path = "${mulgara_base_dir}/${package}.jar"
  $mulgara_initd_log_dir = "${log_dir}"  
  $mulgara_launch_cmd = "java -jar ${package}.jar -p 8088 -u 8089 -s fedora -k localhost"  
  $mulgara_shutdown_cmd = "java -jar ${package}.jar -x"  

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
