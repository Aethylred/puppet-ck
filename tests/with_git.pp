include gcc

class {'ck':
  provider => 'git',
  build    => true,
  install  => true
}
