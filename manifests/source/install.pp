# install ck linraries that have already been built
class ck::source::install (
  $src_dir = $ck::params::src_dir
) inherits ck::params {

  exec{'install_ck_src':
    command => 'make install',
    cwd     => $src_dir,
    creates => '/usr/local/lib/libck.so',
    path    => ['/usr/bin','/bin'],
    require => Exec['configure_ck_src']
  }

}
