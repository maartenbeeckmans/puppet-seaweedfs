class seaweedfs::volume (
  String                     $datacenter,
  Stdlib::Absolutepath       $data_dir,
  Stdlib::Absolutepath       $log_dir,
  Integer                    $max_volumes,
  Integer                    $port,
  String                     $rack,
  Enum['running', 'stopped'] $service_ensure,
  Boolean                    $service_enable,
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

  ::systemd::unit_file{ 'seaweedfs-volume.service':
    content => template('seaweedfs/seaweedfs-volume.service.erb'),
    notify  => Service['seaweedfs-volume'],
  }

  service { 'seaweedfs-volume':
    ensure => $service_ensure,
    enable => $service_enable,
  }
}
