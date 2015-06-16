# Downloads the ck source code from a git repository
class ck::source::git (
  $git_url = $ck::params::git_url,
  $version = $ck::params::version,
  $src_dir = $ck::params::src_dir
) inherits ck::params {

  $git_src_dir = "${src_dir}-git-${version}"

  vcsrepo{$git_src_dir:
    ensure   => 'present',
    provider => 'git',
    source   => $git_url,
    revision => $version,
  }

  file{'ck_git_src_dir':
    ensure  => 'directory',
    path    => $git_src_dir,
    require => Vcsrepo[$git_src_dir],
  }

  file{'ck_src_dir':
    ensure => 'link',
    path   => $src_dir,
    target => $git_src_dir,
  }
}
