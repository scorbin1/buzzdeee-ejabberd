# == Class: ejabberd
#
# Full description of class ejabberd here.
#
# === Parameters
#
# @param servercertfile
#   Type: String
#   Default Value: '/etc/ejabberd/mycert.pem'
#   Description: The path where the server certificate file already exists or should
#                otherwise be installed, depending on templatestorage parameter value
#
# @param templatestorage
#   Type: Enum['puppet','hiera','none']
#   Default Value: 'puppet'
#   Description: Define how to source/create certificate file 
#     'puppet' - source certificate file from puppet hosted file ejabberd/ejabberd.pem
#                Bug: This option not working on debian linux.  Likely relative source
#                     paths are deprecated feature
#     'hiera'  - source certificate file via hiera lookup using file name defined in
#                $servercertfile, with file path removed, as the argument to hiera()
#     'none'   - Set to this value if server ssl certificate already exists or is defined
#                externally. $servercertfile should still be defined for use in configuration
#
# @param ejabberd_group
#   Type: String
#   Default Value: '_ejabberd'
#   Description: The group that should own the server certificate file. User is always root.
#
# @param package_ensure
#   Type: valid package resource ensure value.  See package resource documentation for
#         more information
#   Default Value: 'installed'
#   Description: Package version or any other value acceptable by the ensure attribute
#                of a package resource
#
# @param service_ensure
#   Type: String
#   Default Value: 'running'
#   Description: Desired ejabberd service resource status. This parameter
#                accepts valid service resource ensure values. See service
#                resource documentation for more information
#
# @param service_enable
#   Type: Boolean
#   Default Value: true
#   Description: Whether service should be started on boot
#
# @param service_flags
#   Type: String
#   Default Value: ''
#   Description: String of parameters to pass to the service when starting
#
# @param log_level
#   Type: String
#   Default Value: 'info'
#   Description: Verbosity of log files generated by ejabberd
#
# @param log_rotate_count
#   Type: Integer
#   Default Value: 0 - Debian, 1 - all others
#   Description: The number of rotated log files to keep.  Defaults to 0 on
#                debian as debian uses logrotate.
#
# @param domains
#   Type: Variant[Array[String], String]
#   Default Value: ['example.net', 'example.com', 'example.org']
#   Description: Domains served by ejabberd. Can be a single domain as a String
#                or a list of domains as an array of Strings
#
# @param tls_options
#   Type: Variant[Array[String], String]
#   Default Value: ['no_sslv3','no_tlsv1','no_tlsv1_1','cipher_server_preference','no_compression']
#   Description: TLS Options for ejabberd
#
# @param auth_method
#   Type: Enum['anonymous','external','internal','ldap','sql','pam','jwt']
#   Default Value: 'internal'
#   Description: Login authentication mechanism to use with ejabberd
#     Acceptable values:
#       'anonymous' - Do not require authentication
#       'external'  - Use external script to authentacte
#       'internal'  - Use internal mnesia db to authenticate
#       'ldap'      - Use an ldap backend to authenticate users
#       'sql'       - Use an sql db to authenticate users
#       'pam'       - Use pam to authenticate users
#       'jwt'       - Use jwt to authenticate users
#
# @param auth_attrs
#   Type: Struct[{
#           servers    => Variant[Array[String], String],
#           uidattr    => String,
#           port       => Enum[389, 636],
#           encrypt    => Enum['none', 'tls'],
#           searchbase => String,
#           rootdn     => String,
#           password   => String,
#           ldapfilter => String,
#         }] 
#   Default Values: defined by calling class
#   Struct Members:
#     servers    - String or Array of Strings - LDAP server name(s)
#     uidattr    - String                     - LDAP attribute that holds a users username
#     port       - Enum[389, 636]             - LDAP Server port
#     encrypt    - Enum['none', 'tls']        - Encryption type to use
#     searchbase - String                     - LDAP search base
#     rootdn     - String                     - LDAP Manager user dn
#     password   - String                     - LDAP Manager password
#     ldapfilter - String                     - LDAP search filter
#
# @param transports
#   Type: Hash
#   Default Value: defined by calling class
#   Description: This should be a hash of transport resource definitions
#
# @param enable_stun
#   Type: Boolean
#   Default Value: defined by calling class
#   Description: Whether or not to enable the stun server
#
# @param db_backend
#   Type: Enum['mssql', 'mysql', 'postgresql', 'mnesia']
#   Default Value: defined by calling class
#   Description: Database backend to use
#
# @param db_params
#   Type: String
#   Default Value: defined by calling class
#   Description: Does not seem to be implemented yet.  Placeholder for now.
#
# @param language
#   Type: String
#   Default Value: defined by calling class 
#   Description: Default language used for server messages.  Accepts valid
#                language codes.  ie... en,ru,cn
#
# @param enable_firewall_rules
#   Type: Boolean
#   Default Value: false
#   Description: If enabled and firewall enabled, configure rules for ejabberd
#
# @param ejabberd_allowed_clients
#   Type: Array
#   Default value: ['0.0.0.0/0']
#   An array of IPs permitted to access ejabberd
#
# @param ejabberd_firewall_rule_order
#   Type: Integer
#   Default value: '119'
#   ejabberd firewall rule order.  This sets the order of the rules.  Lower numbered rules are processed first.  Numbers starting with 0 must be single quoted
#
# @param ejabberd_port
#   Type: Integer
#   Default value: '5443'
#   ejabberd service port.
#
# @param ejabberd_xmpp_port
#   Type: Integer
#   Default value: '5222'
#   ejabberd xmpp service port.
#
# @param ejabberd_xmpps_port
#   Type: Integer
#   Default value: '5223'
#   ejabberd xmpps service port.
#
# @param ejabberd_xmpp_s2s_port
#   Type: Integer
#   Default value: '5269'
#   ejabberd xmpp s2s service port.
#
# @param ejabberd_xmpp_admin_ui_port
#   Type: Integer
#   Default value: '5280'
#   ejabberd xmpp admin ui service port.
#
# @param ejabberd_mqtt_port
#   Type: Integer
#   Default value: '1883'
#   ejabberd mqtt service port.
#
# @param mod_register_ips
#   Type: String
#   Default Value: undef
#   Description: IP addresses allowed to register using mod_register
#
# @param mod_register_subject
#   Type: String
#   Default Value: undef
#   Description: Custom subject line for mod_register
#
# @param mod_register_body
#   Type: String
#   Default Value: undef
#   Description: Custom body for mod_register
#
# @param enable_mod_proxy65
#   Type: Boolean
#   Default Value: false
#   Description: Whether to enable proxy65 module
#
# @param mod_proxy65_access
#   Type: String
#   Default Value: undef
#   Description: Custom body for mod_register
#
# @param mod_proxy65_connections
#   Type: String
#   Default Value: undef
#   Description: Custom body for mod_register
#
# @param enable_mod_ping
#   Type: Boolean
#   Default Value: false
#   Description: Whether to enable mod_ping
#
# @param mod_ping_ack_timeout
#   Type: Integer
#   Default Value: 0
#   Description: timeout period in minutes
#
# @param mod_ping_interval
#   Type: Integer
#   Default Value: 0
#   Description: How often to send pings to connected clients
#
# @param mod_ping_timeout_action
#   Type: Enum['none','kill']
#   Default Value: none
#   Description: Action to take on timeout
#
# @param enable_mod_version
#   Type: Boolean
#   Default Value: true
#   Description: Whether to enable mod_version
#
# @param enable_mod_vcard
#   Type: Boolean
#   Default Value: true
#   Description: Whether to enable mod_vcard
#
# @param mod_vcard_search_enable
#   Type: Boolean
#   Default Value: true
#   Description: Whether to enable search for mod_vcard
#
# @param mod_vcard_xupdate_enable
#   Type: Boolean
#   Default Value: true
#   Description: Whether to enable xupdate for mod_vcard
#
# @param enable_mod_avatar
#   Type: Boolean
#   Default Value: true
#   Description: Whether to enable mod_avatar(reqires mod_vcard)
#
# === Examples
#
#  class { 'ejabberd':
#    servers => [ 'pool.ntp.org', 'ntp.local.company.com' ],
#  }
#
# === Authors
#
# Sebastian Reitenbach <sebastia@l00-bugdead-prods.de>
#
# === Copyright
#
# Copyright 2014 Sebastian Reitenbach, unless otherwise noted.
#

type Ejabberd::AuthStruct = Struct[{
    servers    => Variant[Array[String], String],
    uidattr    => String,
    port       => Enum['389', '636'],
    encrypt    => Enum['none', 'tls'],
    searchbase => String,
    rootdn     => String,
    password   => String,
    ldapfilter => String,
}]

class ejabberd (
  Enum['puppet','hiera','none']                               $templatestorage              = $ejabberd::params::templatestorage,
  String                                                      $ejabberd_group               = $ejabberd::params::ejabberd_group,
  String                                                      $log_level                    = $ejabberd::params::log_level,
  Optional[Integer]                                           $log_rotate_count             = $ejabberd::params::log_rotate_count,
  Variant[Array[String], String]                              $domains                      = $ejabberd::params::domains,
  Variant[Array[String], String]                              $tls_options                  = $ejabberd::params::tls_options,
  String                                                      $servercertfile               = $ejabberd::params::servercertfile,
  Enum['anonymous','external','internal','ldap','odbc','pam'] $auth_method                  = $ejabberd::params::auth_method,
  Ejabberd::AuthStruct                                        $auth_attrs                   = $ejabberd::params::auth_attrs,
  Enum['mssql', 'mysql', 'postgresql', 'mnesia']              $db_backend                   = $ejabberd::params::db_backend,
  String                                                      $db_params                    = $ejabberd::params::db_params,
  String                                                      $package_ensure               = $ejabberd::params::package_ensure,
  String                                                      $service_ensure               = $ejabberd::params::service_ensure,
  Boolean                                                     $service_enable               = $ejabberd::params::service_enable,
  String                                                      $service_flags                = $ejabberd::params::service_flags,
  Boolean                                                     $enable_stun                  = $ejabberd::params::enable_stun,
  String                                                      $language                     = $ejabberd::params::language,
  Hash                                                        $transports                   = $ejabberd::params::transports,
  Boolean                                                     $enable_firewall_rules        = $ejabberd::params::enable_firewall_rules,
  Array                                                       $ejabberd_allowed_clients     = $ejabberd::params::ejabberd_allowed_clients,
  Integer                                                     $ejabberd_firewall_rule_order = $ejabberd::params::ejabberd_firewall_rule_order,
  Integer                                                     $ejabberd_port                = $ejabberd::params::ejabberd_port,
  Integer                                                     $ejabberd_xmpp_port           = $ejabberd::params::ejabberd_xmpp_port,
  Integer                                                     $ejabberd_xmpps_port          = $ejabberd::params::ejabberd_xmpps_port,
  Integer                                                     $ejabberd_xmpp_s2s_port       = $ejabberd::params::ejabberd_xmpp_s2s_port,
  Integer                                                     $ejabberd_xmpp_admin_ui_port  = $ejabberd::params::ejabberd_xmpp_admin_ui_port,
  Integer                                                     $ejabberd_mqtt_port           = $ejabberd::params::ejabberd_mqtt_port,
  String                                                      $mod_register_ips             = $ejabberd::params::mod_register_ips,
  String                                                      $mod_register_subject         = $ejabberd::params::mod_register_subject,
  String                                                      $mod_register_body            = $ejabberd::params::mod_register_body,
  Boolean                                                     $enable_mod_proxy65           = $ejabberd::params::enable_mod_proxy65,
  String                                                      $mod_proxy65_access           = $ejabberd::params::mod_proxy65_access,
  Integer                                                     $mod_proxy65_connections      = $ejabberd::params::mod_proxy65_connections,
  Boolean                                                     $enable_mod_ping              = $ejabberd::params::enable_mod_ping,
  Integer                                                     $mod_ping_ack_timeout         = $ejabberd::params::mod_ping_ack_timeout,
  Integer                                                     $mod_ping_interval            = $ejabberd::params::mod_ping_interval,
  Enum['none','kill']                                         $mod_ping_timeout_action      = $ejabberd::params::mod_ping_timeout_action,
  Boolean                                                     $enable_mod_version           = $ejabberd::params::enable_mod_version,
  Boolean                                                     $enable_mod_vcard             = $ejabberd::params::enable_mod_vcard,
  Boolean                                                     $mod_vcard_search_enable      = $ejabberd::params::mod_vcard_search_enable,
  Boolean                                                     $mod_vcard_xupdate_enable     = $ejabberd::params::mod_vcard_xupdate_enable,
  Boolean                                                     $enable_mod_avatar            = $ejabberd::params::enable_mod_avatar,
) inherits ejabberd::params {
  class { 'ejabberd::install':
    package_ensure   => $package_ensure,
  }

  class { 'ejabberd::config':
    ejabberd_group           => $ejabberd_group,
    log_level                => $log_level,
    log_rotate_count         => $log_rotate_count,
    domains                  => $domains,
    tls_options              => $tls_options,
    servercertfile           => $servercertfile,
    auth_method              => $auth_method,
    auth_attrs               => $auth_attrs,
    db_backend               => $db_backend,
    db_params                => $db_params,
    enable_stun              => $enable_stun,
    language                 => $language,
    transports               => $transports,
    mod_register_ips         => $mod_register_ips,
    mod_register_subject     => $mod_register_subject,
    mod_register_body        => $mod_register_body,
    enable_mod_proxy65       => $enable_mod_proxy65,
    mod_proxy65_access       => $mod_proxy65_access,
    mod_proxy65_connections  => $mod_proxy65_connections,
    enable_mod_ping          => $enable_mod_ping,
    mod_ping_ack_timeout     => $mod_ping_ack_timeout,
    mod_ping_interval        => $mod_ping_interval,
    mod_ping_timeout_action  => $mod_ping_timeout_action,
    enable_mod_version       => $enable_mod_version,
    enable_mod_vcard         => $enable_mod_vcard,
    mod_vcard_search_enable  => $mod_vcard_search_enable,
    mod_vcard_xupdate_enable => $mod_vcard_xupdate_enable,
    enable_mod_avatar        => $enable_mod_avatar,
  }

  class { 'ejabberd::certificate':
    ejabberd_group  => $ejabberd_group,
    servercertfile  => $servercertfile,
    templatestorage => $templatestorage,
  }

  class { 'ejabberd::firewall':
    enable                       => $enable_firewall_rules,
    ejabberd_allowed_clients     => $ejabberd_allowed_clients,
    ejabberd_firewall_rule_order => $ejabberd_firewall_rule_order,
    ejabberd_port                => $ejabberd_port,
    ejabberd_xmpp_port           => $ejabberd_xmpp_port,
    ejabberd_xmpps_port          => $ejabberd_xmpps_port,
    ejabberd_xmpp_s2s_port       => $ejabberd_xmpp_s2s_port,
    ejabberd_xmpp_admin_ui_port  => $ejabberd_xmpp_admin_ui_port,
    ejabberd_mqtt_port           => $ejabberd_mqtt_port,
  }

  class { 'ejabberd::service':
    service_ensure => $service_ensure,
    service_enable => $service_enable,
    service_flags  => $service_flags,
  }

  Class['ejabberd::install']
  -> Class['ejabberd::certificate']
  ~> Class['ejabberd::config']
  ~> Class['ejabberd::service']
}
