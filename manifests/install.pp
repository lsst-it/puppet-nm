# @api private
class nm::install {
  assert_private()

  package { 'NetworkManager':
    ensure => present,
  }
}
