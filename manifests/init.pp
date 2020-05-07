class seaweedfs (
  String                     $archive_name,
  String                     $bin_name,
  Stdlib::Absolutepath       $bin_dir,
  Stdlib::Absolutepath       $download_dir,
  String                     $download_url_base,
  String                     $group,
  Enum['archive', 'package'] $install_method,
  Boolean                    $manage_download_dir,
  Boolean                    $manage_group,
  Boolean                    $manage_user,
  Boolean                    $master,
  String                     $package_name,
  String                     $package_ensure,
  String                     $version,
  String                     $user,

  Optional[String]           $download_url = undef,
  Optional[String]           $filer_ip     = undef,
  Optional[Integer]          $filer_port   = undef,
  String                     $ipaddress    = $::ipaddress,
  Optional[String]           $master_ip    = undef,
  Optional[Integer]          $master_port  = undef,
){
  include ::seaweedfs::install
}
