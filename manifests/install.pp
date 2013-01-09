class mulgara::install (
  $source_url, 
  $home_dir = $mulgara::params::home_dir, 
  $data_dir = $mulgara::params::data_dir, 
  $log_dir = $mulgara::params::log_dir, 
  $package = $mulgara::params::package,
  $mulgara_user = $mulgara::params::mulgara_user,
  $mulgara_user_home_dir = $mulgara::params::mulgara_user_home_dir,
  $java_home = $mulgara::params::java_home,
  $create_mulgara_user = $mulgara::params::create_mulgara_user,
  $enable_resource_index = $mulgara::params::enable_resource_index,
  ) inherits mulgara::params {
  $temp_dir = "/var/tmp"
  
  # ensure home dir is setup and installed
  exec { "create_mulgara_home_dir":
    command => "echo 'creating ${home_dir}' && mkdir -p ${home_dir}",
    path => ["/bin", "/usr/bin", "/usr/sbin"],
    creates => $home_dir
  }

  file {$home_dir:
    path    => $home_dir,
    ensure  => directory,
    owner   => $mulgara_user,
    group   => $mulgara_user,
    mode    => 0644,
    require => [Exec["create_mulgara_home_dir"]],
  }

  file {$log_dir:
    path    => $log_dir,
    ensure  => directory,
    owner   => $mulgara_user,
    group   => $mulgara_user,
    mode    => 0644,
    require => [Exec["create_mulgara_home_dir"]],
  }

  file {$data_dir:
    path    => $data_dir,
    ensure  => directory,
    owner   => $mulgara_user,
    group   => $mulgara_user,
    mode    => 0644,
    require => [File["$home_dir"]],
  } 

 if $create_mulgara_user {
    # setup mulgara user    

    file { "${mulgara_user_home_dir}":
      ensure => directory,
      owner => "$mulgara_user",
    }
  
    user {"$mulgara_user":
      ensure => present,
      home => "${mulgara_user_home_dir}",
      before => File["$mulgara_user_home_dir"],
      name => "$mulgara_user",
      system => true,
      shell => "/bin/bash",
    }
  }
 
  # if source url is a valid url, download 
  if $source_url =~ /^http.*/ {
    $source = "${temp_dir}/${package}.tgz"

    exec { "download-mcf":
      command => "wget $source_url --output-document=${package}.tgz",
      creates => "$source",
      cwd => "$temp_dir",
      path => ["/bin", "/usr/bin", "/usr/sbin"],
      require => Exec["create_mulgara_home_dir"],
      before => Exec["unpack-mulgara"],
    }
    
  } else {
    # assumes is a path.. 
    $source = $source_url
  }

  exec {"unpack-mulgara":
    command => "tar --strip-components=1 -xzf ${source} --directory ${home_dir}",
    cwd => $home_dir,
    creates => "$home_dir/dist",
    require => [Exec["create_mulgara_home_dir"]],
    user => $mulgara_user,
    path => ["/bin", "/usr/bin", "/usr/sbin"],
  }
  
  $install_dir = "$home_dir/dist"
 
  file { "${install_dir}/${package}.jar":
    ensure => file,
    owner => $mulgara_user,
    mode => 0644,
    require => Exec["unpack-mulgara"],
  }

}
