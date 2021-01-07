define seaweedfs::filer (
  Stdlib::Absolutepath       $conf_dir        = '/etc/seaweedfs',
  Stdlib::Absolutepath       $data_dir        = "/var/lib/seaweedfs-filer-${title}",
  Stdlib::Absolutepath       $log_dir         = "/var/log/seaweedfs-filer-${title}",
  Integer                    $port            = 8888,
  String                     $replication     = '001',
  Enum['running', 'stopped'] $service_ensure  = 'running',
  Boolean                    $service_enable  = true,
  Stdlib::Absolutepath       $bin_dir         = $::seaweedfs::bin_dir,
  String                     $bin_name        = $::seaweedfs::bin_name,
  String                     $group           = $::seaweedfs::group,
  String                     $ipaddress       = $::seaweedfs::ipaddress,
  String                     $master_ip       = $::seaweedfs::master_ip,
  Integer                    $master_port     = $::seaweedfs::master_port,
  String                     $user            = $::seaweedfs::user,
){
  ensure_resources('file', [$conf_dir, $data_dir, $log_dir] => {
    ensure => 'directory',
    group  => $group,
    owner  => $user,
  })

  ensure_resource(file, "${conf_dir}/filer.toml", {
    content => template('seaweedfs/filer.toml.erb'),
    group   => $group,
    owner   => $group,
    notify  => Service["seaweedfs-filer-${title}"],
  })

  ::systemd::unit_file{ "seaweedfs-filer-${title}.service":
    content => template('seaweedfs/seaweedfs-filer.service.erb'),
    notify  => Service["seaweedfs-filer-${title}"],
  }

  service { "seaweedfs-filer-${title}":
    ensure => $service_ensure,
    enable => $service_enable,
  }
}
