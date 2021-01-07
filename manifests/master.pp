define seaweedfs::master (
  Stdlib::Absolutepath       $log_dir           = "/var/log/seaweedfs-master-${title}",
  Stdlib::Absolutepath       $metadata_dir      = "/var/lib/seaweedfs-master-${title}",
  Integer                    $port              = 9333,
  String                     $replication       = '001',
  Array                      $peers             = [],
  Integer                    $volume_size_limit = 25600,
  Enum['running', 'stopped'] $service_ensure    = 'running',
  Boolean                    $service_enable    = true,
  Stdlib::Absolutepath       $bin_dir           = $::seaweedfs::bin_dir,
  String                     $bin_name          = $::seaweedfs::bin_name,
  String                     $group             = $::seaweedfs::group,
  String                     $ipaddress         = $::seaweedfs::ipaddress,
  String                     $user              = $::seaweedfs::user,
){

  ensure_resources('file', [$log_dir, $metadata_dir] => {
    ensure => 'directory',
    group  => $group,
    owner  => $user,
  })

  ::systemd::unit_file{ "seaweedfs-master-${title}.service":
    content => template('seaweedfs/seaweedfs-master.service.erb'),
    notify  => Service["seaweedfs-master-${title}"],
  }

  service { "seaweedfs-master-${title}":
    ensure => $service_ensure,
    enable => $service_enable,
  }
}
