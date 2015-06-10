# base class for the ck module
class ck (
  $ensure       = 'present',
  $provider     = 'package',
  $dev_libs     = false,
  $packages     = $::ck::params::packages,
  $dev_packages = $::ck::params::dev_packages,
  $manage_repos = false
) inherits ck::params {

  validate_re($provider, ['package','source'])

}
