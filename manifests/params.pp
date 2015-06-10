# Manages shared parameters and variables for the ck module
class ck::params {

  case $::osfamily {
    'Debian':{
      $packages     = ['libck0']
      $dev_packages = ['libck-dev']
    }
    'RedHat':{
      $packages     = undef
      $dev_packages = undef
    }
    default:{
      fail("The ck Puppet module does not support ${::osfamily} family of operating systems")
    }
  }
}
