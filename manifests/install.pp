class mulgara::install (
  $source_url, 
  $home_dir = $mulgara::params::home_dir, 
  $data_dir = $mulgara::params::data_dir, 
  $log_dir = $mulgara::params:log_dir, 
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
      shell => "/bin/false",
    }
  }
 
  # Configure environment variables
  file {"${mulgara_user_home_dir}/.pam_environment":
    ensure => file,
    content => template("mulgara/.pam_environment.erb"),
    owner   => $mulgara_user,
    mode    => 0755,
  }

  # state information should go here like file system db etc
  file {"/var/lib/mulgara":
    ensure  => directory,
    owner   => $mulgara_user,
    mode    => 0644,
    require => File[$home_dir],
  }

  # if source url is a valid url, download solr
  if $source_url =~ /^http.*/ {
    $source = "${dir}/${package}.tgz"

    exec { "download-mcf":
      command => "wget $source_url",
      creates => "$source",
      cwd => "$dir",
      path => ["/bin", "/usr/bin", "/usr/sbin"],
      require => File[$mcf_synchdirectory],
      before => Exec["unpack-mulgara"],
    }
    
  } else {
    # assumes is a path.. 
    $source = $source_url
  }
  
  $install_dir = "$home_dir/mulgara_installation_temp"
 
  file { "${install_dir}":
    ensure => directory,
    owner => "$mulgara_user",
  }
 
  file { "${install_dir}/mulgara.jar":
    ensure => file,
    owner => "$mulgara_user",
    mode => 0755,
    source => $source_url,
    require => [File["${install_dir}"],File[$home_dir]],
  }

}
