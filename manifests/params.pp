# Manages shared parameters and variables for the ck module
class ck::params {

  $src_dir = '/usr/src/ck'
  $version = '0.4.5'

  case $::osfamily {
    'Debian':{
      $packages     = ['libck0']
      $dev_packages = ['libck-dev']
      if $::operatingsystem == 'Ubuntu' {
        if versioncmp($::lsbdistrelease, '14.10') < 0 {
          $repo_url = undef
        } else {
          $repo_url = 'lp:ubuntu/ck'
        }
      } else {
        $repo_url   = 'lp:debian/ck'
      }
    }
    'RedHat':{
      $packages     = undef
      $dev_packages = undef
      $repo_url     = undef
    }
    default:{
      fail("The ck Puppet module does not support ${::osfamily} family of operating systems")
    }
  }
}
