class ejabberd::config (
  $log_level,
  $domains,
  $servercertfile,
  $auth_method,
  $auth_attrs,
  $transports,
  $enable_stun,
  $db_backend,
  $db_params,
  $language,
  $ejabberd_group,
) {
  concat { '/etc/ejabberd/ejabberd.cfg':
    ensure => 'present',
    owner  => 'root',
    group  => $ejabberd_group,
    mode   => '0640',
  }

  concat::fragment { 'ejabberd-header':
    target  => '/etc/ejabberd/ejabberd.cfg',
    content => template('ejabberd/ejabberd-header.cfg.erb'),
    order   => '01',
  }

  if $transports {
    create_resources(ejabberd::transport, $transports)
  }

  concat::fragment { 'ejabberd-after-transports':
    target  => '/etc/ejabberd/ejabberd.cfg',
    content => template('ejabberd/ejabberd-after-transports.cfg.erb'),
    order   => '20',
  }

  concat::fragment { 'ejabberd-authentication':
    target  => '/etc/ejabberd/ejabberd.cfg',
    content => template("ejabberd/ejabberd-auth-${auth_method}.cfg.erb"),
    order   => '30',
  }

  if $db_backend != 'mnesia' {
    concat::fragment { 'ejabberd-database':
      target  => '/etc/ejabberd/ejabberd.cfg',
      content => template("ejabberd/ejabberd-db-${db_backend}.cfg.erb"),
      order   => '40',
    }
  }

  concat::fragment { 'ejabberd-after-database':
    target  => '/etc/ejabberd/ejabberd.cfg',
    content => template('ejabberd/ejabberd-after-dbconfig.cfg.erb'),
    order   => '50',
  }

  concat::fragment { 'ejabberd-acls':
    target  => '/etc/ejabberd/ejabberd.cfg',
    content => template('ejabberd/ejabberd-acls.cfg.erb'),
    order   => '60',
  }

  concat::fragment { 'ejabberd-end':
    target  => '/etc/ejabberd/ejabberd.cfg',
    content => template('ejabberd/ejabberd-end.cfg.erb'),
    order   => '70',
  }

  
}
