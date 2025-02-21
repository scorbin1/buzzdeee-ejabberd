# @api private
#
# !!DO NOT CALL THIS CLASS DIRECTLY!!
# Called by ejabberd::init
#
# @summary configures ejabberd.conf file
class ejabberd::config (
  String                                                      $log_level,
  Integer                                                     $log_rotate_count,
  Variant[Array[String], String]                              $domains,
  Variant[Array[String], String]                              $tls_options,
  String                                                      $servercertfile,
  Enum['anonymous','external','internal','ldap','odbc','pam'] $auth_method,
  Ejabberd::AuthStruct                                        $auth_attrs,
  Hash                                                        $transports,
  Boolean                                                     $enable_stun,
  Enum['mssql','mysql','postgresql','mnesia']                 $db_backend,
  Optional[String]                                            $db_params,
  String                                                      $language,
  String                                                      $ejabberd_group,
  Boolean                                                     $enable_mod_register,
  Boolean                                                     $enable_mod_register_web,
  String                                                      $mod_register_ips_allowed,
  String                                                      $mod_register_welcome_msg_subject,
  String                                                      $mod_register_welcome_msg_body,
  Boolean                                                     $enable_mod_proxy65,
  String                                                      $mod_proxy65_access,
  Integer                                                     $mod_proxy65_connections,
  Boolean                                                     $enable_mod_ping,
  Integer                                                     $mod_ping_ack_timeout,
  Integer                                                     $mod_ping_interval,
  Enum['none','kill']                                         $mod_ping_timeout_action,
  Boolean                                                     $enable_mod_version,
  Boolean                                                     $enable_mod_vcard,
  Boolean                                                     $mod_vcard_search_enable,
  Boolean                                                     $mod_vcard_xupdate_enable,
  Boolean                                                     $enable_mod_avatar,
  Variant[Array[String], String]                              $admin_users,
) {
  case $facts['os']['family'] {
    'Debian': {
      $config_filename = '/etc/ejabberd/ejabberd.yml'
      $config_set      = '.Debian'
    }

    default: {
      $config_filename = '/etc/ejabberd/ejabberd.cfg'
      $config_set      = ''
    }
  }

  concat { $config_filename:
    ensure => 'present',
    owner  => 'root',
    group  => $ejabberd_group,
    mode   => '0640',
  }

  concat::fragment { 'ejabberd-general':
    target  => $config_filename,
    content => template("ejabberd/ejabberd-general.cfg${config_set}.erb"),
    order   => '01',
  }

  concat::fragment { 'ejabberd-ports':
    target  => $config_filename,
    content => template("ejabberd/ejabberd-ports.cfg${config_set}.erb"),
    order   => '02',
  }

  if $transports {
    create_resources(ejabberd::transport, $transports)
  }

  concat::fragment { 'ejabberd-encryption':
    target  => $config_filename,
    content => template("ejabberd/ejabberd-encryption.cfg${config_set}.erb"),
    order   => '20',
  }

  concat::fragment { 'ejabberd-acls':
    target  => $config_filename,
    content => template("ejabberd/ejabberd-acls.cfg${config_set}.erb"),
    order   => '30',
  }

  if $facts['os']['family'] != 'Debian' {
    concat::fragment { 'ejabberd-authentication':
      target  => $config_filename,
      content => template("ejabberd/ejabberd-auth-${auth_method}.cfg${config_set}.erb"),
      order   => '40',
    }

    if $db_backend != 'mnesia' {
      concat::fragment { 'ejabberd-database':
        target  => $config_filename,
        content => template("ejabberd/ejabberd-db-${db_backend}.cfg${config_set}.erb"),
        order   => '50',
      }
    }
  }

  concat::fragment { 'ejabberd-shaper':
    target  => $config_filename,
    content => template("ejabberd/ejabberd-shaper.cfg${config_set}.erb"),
    order   => '60',
  }

  concat::fragment { 'ejabberd-modules':
    target  => $config_filename,
    content => template("ejabberd/ejabberd-modules.cfg${config_set}.erb"),
    order   => '70',
  }

  concat::fragment { 'ejabberd-end':
    target  => $config_filename,
    content => template("ejabberd/ejabberd-end.cfg${config_set}.erb"),
    order   => '80',
  }
}
