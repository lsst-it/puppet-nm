# @api private
class nm::service {
  assert_private()

  Service { 'NetworkManager':
    ensure => 'running',
    enable => true,
  }
}
