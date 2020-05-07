class seaweedfs::install (
  $archive_name        = $::seaweedfs::archive_name,
  $bin_name            = $::seaweedfs::bin_name,
  $bin_dir             = $::seaweedfs::bin_dir,
  $download_dir        = $::seaweedfs::download_dir,
  $download_url        = $::seaweedfs::download_url,
  $download_url_base   = $::seaweedfs::download_url_base,
  $group               = $::seaweedfs::group,
  $install_method      = $::seaweedfs::install_method,
  $manage_download_dir = $::seaweedfs::manage_download_dir,
  $manage_group        = $::seaweedfs::manage_group,
  $manage_user         = $::seaweedfs::manage_user,
  $user                = $::seaweedfs::user,
  $version             = $::seaweedfs::version,
) {

  $_download_url = $download_url ? {
    undef   => "${download_url_base}/${version}/${archive_name}",
    default => $download_url,
  }

  case $install_method {
    'archive': {
      if $manage_download_dir {
        file { $download_dir :
          ensure =>  'directory',
        }
      }

      archive { "${download_dir}/${archive_name}":
        ensure       => 'present',
        cleanup      => true,
        creates      => $bin_name,
        extract      => true,
        extract_path => $bin_dir,
        source       => $_download_url,
      }
    }
    'package': {
      package { $package_name:
        ensure => $package_ensure,
      }
    }
  }

  if $manage_group {
    group { $group:
      ensure => 'present',
    }
  }

  if $manage_user {
    user { $user:
      ensure  => 'present',
      system  => true,
      require => Group[$group],
    }
  }
}
