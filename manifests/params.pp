# Private class, do not use directly.
# These parameters drive the module.

class ejabberd::params {
  $templatestorage = 'puppet'

  case $facts['os']['family'] {
    'Debian': {
      $ejabberd_group  = 'ejabberd'
    }

    default: {
      $ejabberd_group  = '_ejabberd'
    }
  }

  $enable_firewall_rules        = false
  $ejabberd_allowed_clients             = ['0.0.0.0/0']
  $ejabberd_firewall_rule_order = 119
  $ejabberd_port                = 5443
  $ejabberd_xmpp_port           = 5222
  $ejabberd_xmpps_port          = 5223
  $ejabberd_xmpp_s2s_port       = 5269
  $ejabberd_xmpp_admin_ui_port  = 5280
  $ejabberd_mqtt_port           = 1883

  $log_level = 'info'
  $domains = ['example.net', 'example.com', 'example.org']
  $servercertfile = '/etc/ejabberd/mycert.pem'
  $auth_method = 'internal'
  $transports = {}
  $auth_attrs = {
    servers    => 'localhost',
    uidattr    => 'uid',
    port       => '389',
    encrypt    => 'none',
    searchbase => 'ou=people,dc=example,dc=com',
    rootdn     => 'cn=manager,dc=example,dc=com',
    password   => 'changeme',
    ldapfilter => '(objectClass=shadowAccount)',
  }
  $db_backend = 'mnesia'
  $db_params  = ''
  $enable_stun = true
  $language = 'en'
  $package_ensure = 'installed'
  $service_ensure = 'running'
  $service_enable = true
  $service_flags = ''
  $pidfile = '/var/run/ejabberd/ejabberd.pid'
}
