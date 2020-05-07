class seaweedfs::filer (
  Stdlib::Absolutepath       $conf_dir,
  Stdlib::Absolutepath       $data_dir,
  Stdlib::Absolutepath       $log_dir,
  Integer                    $port,
  String                     $replication,
  Enum['running', 'stopped'] $service_ensure,
  Boolean                    $service_enable,
  Stdlib::Absolutepath       $bin_dir         = $::seaweedfs::bin_dir,
  String                     $bin_name        = $::seaweedfs::bin_name,
  String                     $group           = $::seaweedfs::group,
  String                     $ipaddress       = $::seaweedfs::ipaddress,
  String                     $master_ip       = $::seaweedfs::master_ip,
  Integer                    $master_port     = $::seaweedfs::master::port,
  String                     $user            = $::seaweedfs::user,
){
  ensure_resources('file', [$conf_dir, $data_dir, $log_dir] => {
    ensure => 'directory',
    group  => $group,
    owner  => $user,
  })

  file { "${conf_dir}/filer.toml":
    content => template('seaweedfs/filer.toml.erb'),
    group   => $group,
    owner   => $group,
    notify  => Service['seaweedfs-filer'],
  }

  ::systemd::unit_file{ 'seaweedfs-filer.service':
    content => template('seaweedfs/seaweedfs-filer.service.erb'),
    notify  => Service['seaweedfs-filer'],
  }

  service { 'seaweedfs-filer':
    ensure => $service_ensure,
    enable => $service_enable,
  }
}
