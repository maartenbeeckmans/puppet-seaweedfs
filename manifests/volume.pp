define seaweedfs::volume (
  String                     $datacenter      = 'dc1',
  Stdlib::Absolutepath       $data_dir        = "/seaweedfs-${title}",
  Stdlib::Absolutepath       $log_dir         = "/var/log/seaweedfs-volume-${title}",
  Integer                    $max_volumes     = 8,
  Integer                    $port            = 8080,
  String                     $rack            = 'rack1',
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
  ensure_resources('file', [$data_dir, $log_dir] => {
    ensure => 'directory',
    group  => $group,
    owner  => $user,
  })

  ::systemd::unit_file{ "seaweedfs-volume-${title}.service":
    content => template('seaweedfs/seaweedfs-volume.service.erb'),
    notify  => Service["seaweedfs-volume-${title}"],
  }

  service { "seaweedfs-volume-${title}":
    ensure => $service_ensure,
    enable => $service_enable,
  }
}
