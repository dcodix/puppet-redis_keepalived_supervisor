class rediskeepalived {

  $keepalived_conf_dir = "/etc/keepalived"
  $redis_conf_dir = "/etc/redis"
  $redis_data_dir = "/var/lib/redis"

  $daemon = "supervisord"

  $conf_dir = "/etc/supervisord.d"

  $conf_files_dir = "/etc/supervisord.d"

  $main_conf = "/etc/supervisord.conf"

  $init_dir = "/etc/init.d"


  package { "keepalived": ensure => installed }
  package { "redis": ensure => installed }

  file { "${$keepalived_conf_dir}":
    ensure => "directory",
    owner => root, group => root, mode => 755,
    require => package["keepalived"],
  }
  file {"keepalived.conf":
    path => "${$keepalived_conf_dir}/keepalived.conf",
    owner => root, group => root, mode => 644,
    source => "puppet:///modules/rediskeepalived/keepalived/keepalived.conf",
    require => file["${$keepalived_conf_dir}"],
  }
  file { "conf.d":
    path => "${$keepalived_conf_dir}/conf.d",
    ensure => "directory",
    owner => root, group => root, mode => 755,
    require => file["${$keepalived_conf_dir}"],
  }
  file { "enable-diable":
    path => "${$keepalived_conf_dir}/enable-diable",
    ensure => "directory",
    owner => root, group => root, mode => 755,
    require => file["${$keepalived_conf_dir}"],
  }
  exec { "chkconfig_keepalived_off":
    command => "/sbin/chkconfig keepalived off",
    refreshonly => true,
  }
  file {"keepalived":
    path => "${init_dir}/keepalived",
    owner => root, group => root, mode => 755,
    source => "puppet:///modules/rediskeepalived/keepalived/keepalived.init",
    notify => Exec["chkconfig_keepalived_off"],
  }

  user { "redis":
    home => "/var/lib/redis",
    shell => "/sbin/nologin",
    comment => "Redis Server",
    gid => "redis",
    ensure => present,
    require => package["redis"],
  }
  file { "${redis_conf_dir}":
    ensure => "directory",
    owner => root, group => root, mode => 755,
    require => package["redis"],
  }
  file { "${redis_data_dir}":
    ensure => "directory",
    owner => redis, group => redis, mode => 755,
    require => package["redis"],
  }
  exec { "chkconfig_redis_off":
    command => "/sbin/chkconfig redis off",
    refreshonly => true,
  }
  file {"redis":
    path => "${init_dir}/redis",
    owner => root, group => root, mode => 755,
    source => "puppet:///modules/rediskeepalived/redis/redis.init",
    notify => Exec["chkconfig_redis_off"],
  }
  service { "redis":
    enable => false,
    #ensure => stopped,
    pattern => "redis",
    require => package["redis"],
  }

  file {"redis-keepalived.sh":
    path => "/usr/local/bin/redis-keepalived.sh",
    owner => root, group => root, mode => 755,
    source => "puppet:///modules/rediskeepalived/keepalived/redis-keepalived.sh",
  }



}
