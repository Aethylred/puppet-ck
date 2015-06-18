# Downloads and extracts the source from a tar archive
class ck::source::tar (
  $src_url = undef,
  $src_dir = $ck::params::src_dir,
  $version = $ck::params::version
) inherits ck::params {

  $download_dir = "${src_dir}-${version}"

  if $src_url {
    $real_src_url = $src_url
  } else {
    $real_src_url = "http://concurrencykit.org/releases/ck-${version}.tar.gz"
  }

  file{'ck_src_download_dir':
    ensure => 'directory',
    path   => $download_dir
  }

  exec{'get_ck_source_tarball':
    path    => ['/usr/bin','/bin'],
    command => "wget -O - ${real_src_url}|tar xzv -C ${download_dir} --strip-components=1",
    creates => "${download_dir}/README",
    require => File['ck_src_download_dir']
  }

  file{'ck_src_dir':
    ensure => 'link',
    path   => $src_dir,
    target => $download_dir,
  }
}
