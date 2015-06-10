# Class: ck::params
#
# This class manages shared prameters and variables for the ck module
#
# Parameters:
#
# Actions:
#
# Requires:
#
# Sample Usage:
#
# [Remember: No empty lines between comments and class definition]
class ck::params {

  case $::osfamily {
    Debian:{
      # Do nothing
    }
    default:{
      fail("The ck Puppet module does not support ${::osfamily} family of operating systems")
    }
  }
}
