class seaweedfs::master (
  Stdlib::Absolutepath       $log_dir,
  Stdlib::Absolutepath       $metadata_dir,
  Integer                    $port,
  String                     $replication,
  Enum['running', 'stopped'] $service_ensure,
  Boolean                    $service_enable,
  Stdlib::Absolutepath       $bin_dir         = $::seaweedfs::bin_dir,
  String                     $bin_name        = $::seaweedfs::bin_name,
  String                     $group           = $::seaweedfs::group,
  String                     $ipaddress       = $::seaweedfs::ipaddress,
  String                     $user            = $::seaweedfs::user,
){

  ensure_resources('file', [$log_dir, $metadata_dir] => {
    ensure => 'directory',
    group  => $group,
    owner  => $user,
  })

  ::systemd::unit_file{ 'seaweedfs-master.service':
    content => template('seaweedfs/seaweedfs-master.service.erb'),
    notify  => Service['seaweedfs-master'],
  }

  service { 'seaweedfs-master':
    ensure => $service_ensure,
    enable => $service_enable,
  }
}
