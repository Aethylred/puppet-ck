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
  $git_url      = undef
) inherits ck::params {

  validate_re($provider, ['package','source','git'])

  case $provider {
    'package': {
      if $manage_repos {
        class{'ck::repository':
          repo_url => $repo_url
        }
      }
    }
    'source': {

    }
    'git': {

    }
    default:{
      #Does nothing
    }
  }

}
