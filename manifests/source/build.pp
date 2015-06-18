# Build from source
class ck::source::build (
  $src_dir     = $ck::params::src_dir,
  $regressions = false
) inherits ck::params {

  require gcc

  exec{'configure_ck_src':
    command => 'configure',
    cwd     => $src_dir,
    path    => ['/usr/bin','/bin']
  }

  if $regressions {
    exec{'make_regressions_ck_src':
      command => 'make regressions',
      cwd     => $src_dir,
      path    => ['/usr/bin','/bin'],
      before  => Exec['make_ck_src'],
      require => Exec['configure_ck_src']
    }
  }

  exec{'make_ck_src':
    command => 'make',
    cwd     => $src_dir,
    path    => ['/usr/bin','/bin'],
    require => Exec['configure_ck_src']
  }
}
