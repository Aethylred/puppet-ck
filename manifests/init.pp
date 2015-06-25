# base class for the ck module
class ck (
  $ensure       = 'present',
  $provider     = 'package',
  $version      = $::ck::params::version,
  $dev_libs     = false,
  $packages     = $::ck::params::packages,
  $dev_packages = $::ck::params::dev_packages,
  $manage_repos = false,
  $src_dir      = $::ck::params::src_dir,
  $repo_url     = undef,
  $src_url      = undef,
  $git_url      = undef,
  $build        = false,
  $regressions  = false
) inherits ck::params {

  validate_re($provider, ['package','tar','git'])

  case $provider {
    'package': {
      if $manage_repos {
        class{'ck::repository':
          repo_url => $repo_url,
        }
      }
      if $packages {
        package{$packages:
          ensure => $ensure,
        }
      } else {
        fail("ck package names must be provided for ${::operatingsystem}")
      }
      if $dev_libs {
        if $dev_packages{
          package{$dev_packages:
            ensure => $ensure,
          }
          } else {
            fail("ck development package names must be provided for ${::operatingsystem}")
          }
      }
    }
    'tar','git': {
      case $provider {
        'git':{
          class{'ck::source::git':
            git_url => $git_url,
            version => $version,
            src_dir => $src_dir,
            before  => Anchor['before_build']
          }
        }
        default:{
          class{'ck::source::tar':
            src_url => $src_url,
            src_dir => $src_dir,
            version => $version,
            before  => Anchor['before_build']
          }
        }
      }
      anchor{'before_build': }
      if $build {
        class{'ck::source::build':
          src_dir     => $src_dir,
          regressions => $regressions,
          require     => Anchor['before_build']
        }
        class{'ck::source::install':
          src_dir => $src_dir
        }
      }
    }
    default:{
      # Does nothing
    }
  }

}
