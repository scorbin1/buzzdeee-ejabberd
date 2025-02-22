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
  Boolean                                                     $enable_mod_webpresence,
  Boolean                                                     $enable_mod_pottymouth,
  Boolean                                                     $enable_mod_s2s_log,
  Boolean                                                     $enable_mod_muc_log_http,
  Boolean                                                     $enable_mod_pres_counter,
  Integer                                                     $mod_pres_counter_count,
  Integer                                                     $mod_pres_counter_interval,
  Boolean                                                     $enable_mod_adhoc,
  Boolean                                                     $enable_mod_admin_extra,
  Boolean                                                     $enable_mod_blocking,
  Boolean                                                     $enable_mod_bosh,
  Boolean                                                     $enable_mod_caps,
  Boolean                                                     $enable_mod_carboncopy,
  Boolean                                                     $enable_mod_client_state,
  Boolean                                                     $enable_mod_configure,
  Boolean                                                     $enable_mod_delegation,
  Boolean                                                     $enable_mod_disco,
  Boolean                                                     $enable_mod_fail2ban,
  Boolean                                                     $enable_mod_http_api,
  Boolean                                                     $enable_mod_last,
  Boolean                                                     $enable_mod_mqtt,
  Boolean                                                     $enable_mod_muc_admin,
  Boolean                                                     $enable_mod_privacy,
  Boolean                                                     $enable_mod_private,
  Boolean                                                     $enable_mod_push,
  Boolean                                                     $enable_mod_push_keepalive,
  Boolean                                                     $enable_mod_s2s_dialback,
  Boolean                                                     $enable_mod_shared_roster,
  Boolean                                                     $enable_mod_sic,
  Boolean                                                     $enable_mod_stun_disco,
) {
  $config_filename = '/etc/ejabberd/ejabberd.yml'

  concat { $config_filename:
    ensure => 'present',
    owner  => 'ejabberd',
    group  => $ejabberd_group,
    mode   => '0600',
  }

  concat::fragment { 'ejabberd-general':
    target  => $config_filename,
    content => template('ejabberd/ejabberd-general.cfg.erb'),
    order   => '01',
  }

  concat::fragment { 'ejabberd-ports':
    target  => $config_filename,
    content => template('ejabberd/ejabberd-ports.cfg.erb'),
    order   => '02',
  }

  if $transports {
    create_resources(ejabberd::transport, $transports)
  }

  concat::fragment { 'ejabberd-encryption':
    target  => $config_filename,
    content => template('ejabberd/ejabberd-encryption.cfg.erb'),
    order   => '20',
  }

  concat::fragment { 'ejabberd-acls':
    target  => $config_filename,
    content => template('ejabberd/ejabberd-acls.cfg.erb'),
    order   => '30',
  }

  if $facts['os']['family'] != 'Debian' {
    concat::fragment { 'ejabberd-authentication':
      target  => $config_filename,
      content => template("ejabberd/ejabberd-auth-${auth_method}.cfg.erb"),
      order   => '40',
    }

    if $db_backend != 'mnesia' {
      concat::fragment { 'ejabberd-database':
        target  => $config_filename,
        content => template("ejabberd/ejabberd-db-${db_backend}.cfg.erb"),
        order   => '50',
      }
    }
  }

  concat::fragment { 'ejabberd-shaper':
    target  => $config_filename,
    content => template('ejabberd/ejabberd-shaper.cfg.erb'),
    order   => '60',
  }

  concat::fragment { 'ejabberd-modules':
    target  => $config_filename,
    content => template('ejabberd/ejabberd-modules.cfg.erb'),
    order   => '70',
  }

  concat::fragment { 'ejabberd-end':
    target  => $config_filename,
    content => template('ejabberd/ejabberd-end.cfg.erb'),
    order   => '80',
  }
}
