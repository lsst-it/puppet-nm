# @api private
class nm::install {
  assert_private()

  stdlib::ensure_packages(['NetworkManager'])
}
