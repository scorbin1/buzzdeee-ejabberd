define ejabberd::transport (
  $port,
  $hosts,
  $password,
) {

  concat::fragment { "ejabberd-transport-${title}":
    target  => '/etc/ejabberd/ejabberd.cfg',
    content => template('ejabberd/ejabberd-transport.cfg.erb'),
    order   => '10',
  }
}
