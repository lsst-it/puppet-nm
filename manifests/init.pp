# @summary
#   Manage NetworkManager
#
# @param conf
#   If a String:
#   Verbatim content of `NetworkManager.conf`.
#
#   If a Hash:
#   Hash of data to serialize to `NetworkManager.conf`.
#
#   See: https://networkmanager.dev/docs/api/latest/nm-settings-keyfile.html
#
# @param connections
#   Hash of nm::connection resources to create
#
# @param purge_connections
#   If `true` unmanaged connections will be purged.
#
class nm (
  Optional[Variant[String[1], Hash[String, Hash]]] $conf = undef,
  Optional[Hash[String, Hash]] $connections = undef,
  Boolean $purge_connections = true,
) {
  $conf_dir= '/etc/NetworkManager'
  $conf_d_dir= "${conf_dir}/conf.d"
  $conn_dir = "${conf_dir}/system-connections"

  include nm::install
  include nm::service

  $_ignore = $facts['os']['release']['major'] ? {
    '7'      => undef,
    '8'      => undef,
    default => 'readme-ifcfg-rh.txt',
  }

  # remove ifcfg-* files to prevent conflicts between ifcfg- and .nmconnection
  file { '/etc/sysconfig/network-scripts':
    ensure  => 'directory',
    purge   => true,
    recurse => true,
    force   => true,
    ignore  => $_ignore,
  }

  # remove any conflicting nm drop-in config files
  file { $conf_d_dir:
    ensure  => 'directory',
    purge   => true,
    recurse => true,
    force   => true,
  }

  # write NetworkManager.conf
  $ini_config = { 'quote_char' => undef }

  $_real_conf= $conf? {
    String  => $conf,
    Hash    => extlib::to_ini($conf, $ini_config),
    default => undef,
  }

  file { "${conf_dir}/NetworkManager.conf":
    ensure  => 'file',
    mode    => '0644',
    content => $_real_conf,
    notify  => Service['NetworkManager'],
  }

  # remove unmanaged .nmconnection files
  file { $conn_dir:
    ensure  => 'directory',
    purge   => $purge_connections,
    recurse => $purge_connections,
    force   => true,
  }

  if $connections {
    $connections.each | $_name, $_params  | {
      nm::connection { $_name:
        * => $_params,
      }
    }
  }

  exec { 'nmcli conn reload':
    command     => '/bin/nmcli conn reload',
    refreshonly => true,
    timeout     => 30,
    tries       => 3,
    try_sleep   => 10,
  }
}
