define rediskeepalived::config () {
  file { "${rediskeepalived::keepalived_conf_dir}/conf.d/redis-$title.conf":
    owner => root, group => root, mode => 644,
    source => "puppet:///modules/rediskeepalived/keepalived/conf.d/redis-$title.conf",
  }
  file { "${rediskeepalived::keepalived_conf_dir}/enable-diable/redis-$title.enable":
    owner => root, group => root, mode => 644,
    #source => "puppet:///modules/rediskeepalived/keepalived/enable-diable/redis-$title.enable",
    ensure => file,
  }
  file { "${rediskeepalived::redis_conf_dir}/redis-$title.conf":
    owner => root, group => root, mode => 644,
    source => "puppet:///modules/rediskeepalived/redis/redis/redis-$title.conf",
  }
  file { "${rediskeepalived::redis_data_dir}/redis-${title}":
    ensure => "directory",
    owner => redis, group => redis, mode => 755,
    require => file["${redis_data_dir}"]

  }

}
