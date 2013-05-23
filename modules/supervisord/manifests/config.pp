define supervisord::config () {
  file { "${supervisord::conf_files_dir}/$title":
    owner => root, group => root, mode => 644,
    source => "puppet:///modules/supervisord/supervisord.d/$title",
    notify => Exec["supervisorctl_update"],
    #require => package["supervisor"],
    require => file["${conf_dir}"],
  }
}
