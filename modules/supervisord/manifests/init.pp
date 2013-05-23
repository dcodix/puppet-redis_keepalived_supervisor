class supervisord {

  $supervisorctl = "/usr/bin/supervisorctl"

  $daemon = "supervisord"

  $conf_dir = "/etc/supervisord.d"

  $conf_files_dir = "/etc/supervisord.d"

  $main_conf = "/etc/supervisord.conf"

  $init_dir = "/etc/init.d"


  package { "supervisor": ensure => installed }

  service { "${daemon}":
    enable => true,
    ensure => running,
    stop => "supervisorctl shutdown",
    pattern => "supervisord",
    }

  file { "${conf_dir}":
    path => "${conf_dir}",
    ensure => "directory",
    owner => root, group => root, mode => 755,
    require => package["supervisor"],
  }

  exec { "supervisorctl_update":
    command => "${supervisorctl} reread && ${supervisorctl} update",
    refreshonly => true,
  }

  exec { "chkconfig_supervisor_on":
    command => "/sbin/chkconfig ${daemon} on",
    refreshonly => true,
  }

  file {"supervisord.conf":
    path => "${main_conf}",
    owner => root, group => root, mode => 644,
    source => "puppet:///modules/supervisord/supervisord.conf",
    notify => Exec["supervisorctl_update"],
  }

  file {"supervisord":
    path => "${init_dir}/${title}",
    owner => root, group => root, mode => 755,
    source => "puppet:///modules/supervisord/supervisord.init",
    notify => Exec["chkconfig_supervisor_on"],
  }

}
