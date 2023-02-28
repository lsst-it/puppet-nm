# @api private
class nm::install {
  assert_private()

  ensure_packages(['NetworkManager'])
}
