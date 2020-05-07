define seaweedfs::mount (
  Stdlib::AbsolutePath       $mount_dir,
  Enum['running', 'stopped'] $service_ensure  = 'running',
  Boolean                    $service_enable  = true,
  String                     $service_name    = $title,
  Stdlib::Absolutepath       $bin_dir         = $::seaweedfs::bin_dir,
  String                     $bin_name        = $::seaweedfs::bin_name,
  String                     $group           = $::seaweedfs::group,
  String                     $filer_ip        = $::seaweedfs::filer_ip,
  Integer                    $filer_port      = $::seaweedfs::filer_port,
  String                     $user            = $::seaweedfs::user,
){

  include ::seaweedfs

  $log_dir = "/var/log/seaweedfs-mount-${service_name}"

  ensure_resources('file', [$mount_dir, $log_dir] => {
    ensure => 'directory',
    group  => $group,
    owner  => $user,
  })

  ::systemd::unit_file{ "seaweedfs-mount-${service_name}.service":
    content => template('seaweedfs/seaweedfs-mount.service.erb'),
    notify  => Service["seaweedfs-mount-${service_name}"],
  }

  service { "seaweedfs-mount-${service_name}":
    ensure => $service_ensure,
    enable => $service_enable,
  }
}
