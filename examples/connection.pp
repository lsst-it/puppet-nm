include nm

nm::connection { 'test':
  content => {
    'connection' => {
      'id'             => 'test',
      'type'           => 'ethernet',
      'interface-name' => 'test',
    },
    'ipv4'       => {
      'address1' => '10.10.10.10/24',
      'method'   => 'manual',
    },
    'ipv6'       => {
      'method' => 'disable',
    },
  },
}
