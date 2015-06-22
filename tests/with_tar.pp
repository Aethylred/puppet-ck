include gcc

class {'ck':
  provider => 'tar',
  build    => true,
  install  => true
}
