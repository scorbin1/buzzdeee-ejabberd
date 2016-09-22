# Private class, do not use directly.
# These parameters drive the module.

class ejabberd::params {
  $templatestorage = 'puppet'
  $ejabberd_group = '_ejabberd'
  $log_level = '1'
  $domains = ['example.net', 'example.com', 'example.org']
  $servercertfile = '/etc/ejabberd/mycert.pem'
  $auth_method = 'ldap'
  $transports = undef
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
  $db_params  = undef
  $enable_stun = true
  $language = 'en'
  $package_ensure = 'installed'
  $service_ensure = 'running'
  $service_enable = true
  $service_flags = undef
  $pidfile = '/var/run/ejabberd/ejabberd.pid'
}
