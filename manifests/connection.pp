# @summary
#  Create a .nmconnection file
#
# @param content
#   If a String:
#   Verbatim content of .nmconnection "keyfile".
#
#   If a Hash:
#   Hash of data to serialize to a .nmconnection "keyfile".
#
#   See: https://networkmanager.dev/docs/api/latest/nm-settings-keyfile.html
#
# @param ensure
#   If connection file should be present or absent.
#
#
define nm::connection (
  Optional[Variant[String[1], Hash[String, Hash]]] $content = undef,
  Enum['present', 'absent'] $ensure = 'present',
) {
  include nm

  $_real_ensure = $ensure ? {
    'absent' => 'absent',
    default  => 'file',
  }

  $ini_config = { 'quote_char' => undef }

  $_real_content = $content ? {
    String  => $content,
    Hash    => extlib::to_ini($content, $ini_config),
    default => undef,
  }

  file { "${nm::conn_dir}/${name}.nmconnection":
    ensure  => $_real_ensure,
    mode    => '0600',
    content => $_real_content,
    notify  => Exec['nmcli conn reload'],
  }
}
