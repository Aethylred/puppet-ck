# manages the package repositories for the Concurrency Kit
class ck::repository (
  $repo_url = undef
) inherits ck::params {
  if $repo_url {
    $real_repo_url = $repo_url
  } else {
    $real_repo_url = $::ck::params::repo_url
  }

  if ! $real_repo_url {
    fail("There is no repository URL for ck for ${::operatingsystem} ${::lsbdistrelease}")
  }
}
