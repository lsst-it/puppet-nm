nm::connection { 'test1':
  content => {
    'connection' => {
      'id'             => 'test1',
      'type'           => 'dummy',
      'interface-name' => 'dummy1',
    },
    'ipv4'       => {
      'address1' => '10.10.10.10/24',
      'method'   => 'manual',
    },
    'ipv6'       => {
      'method' => 'ignore',
    },
  },
}

nm::connection { 'test2':
  content => {
    'connection' => {
      'id'             => 'test2',
      'type'           => 'dummy',
      'interface-name' => 'dummy2',
    },
    'ipv4'       => {
      'address1' => '10.20.20.20/24',
      'method'   => 'manual',
    },
    'ipv6'       => {
      'method' => 'ignore',
    },
  },
}

nm::connection { 'test3':
  # lint:ignore:strict_indent
  content => @(NM),
    [connection]
    id=test3
    type=dummy
    interface-name=dummy3

    [ipv4]
    address1=10.30.30.30/24
    method=manual

    [ipv6]
    method=ignore
    | NM
  # lint:endignore
}
