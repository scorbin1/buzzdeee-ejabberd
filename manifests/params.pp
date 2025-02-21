# Private class, do not use directly.
# These parameters drive the module.

class ejabberd::params {
  $templatestorage = 'none'

  case $facts['os']['family'] {
    'Debian': {
      $ejabberd_group   = 'ejabberd'
      $log_rotate_count = 0
      $servercertfile = '/etc/ejabberd/ejabberd.pem'
    }

    # Module originally written for FreeBSD
    default: {
      $ejabberd_group  = '_ejabberd'
      $log_rotate_count = 1
      $servercertfile = '/etc/ejabberd/mycert.pem'
    }
  }

  $tls_options                  = ['no_sslv3','no_tlsv1','no_tlsv1_1','cipher_server_preference','no_compression']
  $enable_firewall_rules        = false
  $ejabberd_allowed_clients     = ['0.0.0.0/0']
  $ejabberd_firewall_rule_order = 119
  $ejabberd_port                = 5443
  $ejabberd_xmpp_port           = 5222
  $ejabberd_xmpps_port          = 5223
  $ejabberd_xmpp_s2s_port       = 5269
  $ejabberd_xmpp_admin_ui_port  = 5280
  $ejabberd_mqtt_port           = 1883

  $log_level   = 'info'
  $domains     = ['localhost']
  $auth_method = 'internal'
  $transports  = {}
  $auth_attrs  = {
    servers    => 'localhost',
    uidattr    => 'uid',
    port       => '389',
    encrypt    => 'none',
    searchbase => 'ou=people,dc=example,dc=com',
    rootdn     => 'cn=manager,dc=example,dc=com',
    password   => 'changeme',
    ldapfilter => '(objectClass=shadowAccount)',
  }
  $db_backend                       = 'mnesia'
  $db_params                        = ''
  $enable_stun                      = true
  $language                         = 'en'
  $package_ensure                   = 'installed'
  $service_ensure                   = 'running'
  $service_enable                   = true
  $service_flags                    = ''
  $pidfile                          = '/var/run/ejabberd/ejabberd.pid'
  $enable_mod_register              = false
  $enable_mod_register_web          = false
  $mod_register_ips_allowed         = ''
  $mod_register_welcome_msg_subject = ''
  $mod_register_welcome_msg_body    = ''
  $enable_mod_proxy65               = false
  $mod_proxy65_access               = 'local'
  $mod_proxy65_connections          = 5
  $enable_mod_ping                  = false
  $mod_ping_ack_timeout             = 0
  $mod_ping_interval                = 0
  $mod_ping_timeout_action          = none
  $enable_mod_version               = true
  $enable_mod_vcard                 = true
  $mod_vcard_search_enable          = false
  $mod_vcard_xupdate_enable         = true
  $enable_mod_avatar                = true
  $admin_users                      = ''
  $enable_mod_webpresence           = false
  $enable_mod_pottymouth            = false
  $enable_mod_s2s_log               = false
  $enable_mod_muc_log_http          = false
}
