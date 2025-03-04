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
# @param ejabberd_stun_port
#   Type: Integer
#   Default Value: defined by calling class
#   Description: TCP port for ejabberd stun
#
# @param enable_mod_register
#   Type: Boolean
#   Default Value: false
#   Description: Whether to enable mod_register module
#
# @param enable_mod_register_web
#   Type: Boolean
#   Default Value: false
#   Description: Whether to enable mod_register_web module
#
# @param mod_register_ips_allowed
#   Type: String
#   Default Value: undef
#   Description: IP addresses allowed to register using mod_register
#
# @param mod_register_welcome_msg_subject
#   Type: String
#   Default Value: undef
#   Description: Custom subject line for mod_register
#
# @param mod_register_welcome_msg_body
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
#   Description: TODO
#
# @param mod_proxy65_connections
#   Type: String
#   Default Value: undef
#   Description: TODO
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
# @param admin_users
#   Type: Variant[Array[String], String]
#   Default Value: ""
#   Description: users allowed to admin the server
#
# @param enable_mod_webpresence
#   Type: Boolean
#   Default Value: false
#   Description: Whether to enable mod_webpresence
#
# @param enable_mod_pottymouth
#   Type: Boolean
#   Default Value: false
#   Description: Whether to enable mod_pottymouth
#
# @param enable_mod_s2s_log
#   Type: Boolean
#   Default Value: false
#   Description: Whether to enable enable_mod_s2s_log
#
# @param enable_mod_muc_log_http
#   Type: Boolean
#   Default Value: false
#   Description: Whether to enable mod_muc_log_http
#
# @param enable_mod_pres_counter
#   Type: Boolean
#   Default Value: true
#   Description: Whether to enable mod_pres_counter
#
# @param mod_pres_counter_count
#   Type: Integer
#   Default Value: 5
#   Description: The number of subscription presence stanzas
#                (subscribe, unsubscribe, subscribed, unsubscribed)
#                allowed for any direction (input or output) per
#                time defined in interval option. Please note that
#                two users subscribing to each other usually generate
#                4 stanzas, so the recommended value is 4 or more.
#
# @param mod_pres_counter_interval
#   Type: Integer
#   Default Value: 60
#   Description: The time interval
#
# @param enable_mod_adhoc
#   Type: Boolean
#   Default Value: true
#   Description: Whether to enable mod_adhoc
#
# @param enable_mod_admin_extra
#   Type: Boolean
#   Default Value: true
#   Description: Whether to enable mod_admin_extra
#
# @param enable_mod_blocking
#   Type: Boolean
#   Default Value: true
#   Description: Whether to enable mod_blocking
#
# @param enable_mod_bosh
#   Type: Boolean
#   Default Value: true
#   Description: Whether to enable mod_bosh
#
# @param enable_mod_caps
#   Type: Boolean
#   Default Value: true
#   Description: Whether to enable mod_caps
#
# @param enable_mod_carboncopy
#   Type: Boolean
#   Default Value: true
#   Description: Whether to enable mod_carboncopy
#
# @param enable_mod_client_state
#   Type: Boolean
#   Default Value: true
#   Description: Whether to enable mod_pres_counter
#
# @param enable_mod_configure
#   Type: Boolean
#   Default Value: true
#   Description: Whether to enable mod_configure
#
# @param enable_mod_delegation
#   Type: Boolean
#   Default Value: false
#   Description: Whether to enable mod_delegation
#
# @param enable_mod_disco
#   Type: Boolean
#   Default Value: true
#   Description: Whether to enable mod_disco
#
# @param enable_mod_fail2ban
#   Type: Boolean
#   Default Value: true
#   Description: Whether to enable mod_fail2ban
#
# @param enable_mod_http_api
#   Type: Boolean
#   Default Value: true
#   Description: Whether to enable mod_http_api
#
# @param enable_mod_last
#   Type: Boolean
#   Default Value: true
#   Description: Whether to enable mod_last
#
# @param enable_mod_mqtt
#   Type: Boolean
#   Default Value: true
#   Description: Whether to enable mod_mqtt
#
# @param enable_mod_muc_admin
#   Type: Boolean
#   Default Value: true
#   Description: Whether to enable mod_muc_admin
#
# @param enable_mod_privacy
#   Type: Boolean
#   Default Value: true
#   Description: Whether to enable mod_privacy
#
# @param enable_mod_private
#   Type: Boolean
#   Default Value: true
#   Description: Whether to enable mod_private
#
# @param enable_mod_push
#   Type: Boolean
#   Default Value: true
#   Description: Whether to enable enable_mod_push
#
# @param enable_mod_push_keepalive
#   Type: Boolean
#   Default Value: true
#   Description: Whether to enable mod_push_keepalive
#
# @param enable_mod_s2s_dialback
#   Type: Boolean
#   Default Value: true
#   Description: Whether to enable mod_s2s_dialback
#
# @param enable_mod_shared_roster
#   Type: Boolean
#   Default Value: true
#   Description: Whether to enable mod_shared_roster
#
# @param enable_mod_sic
#   Type: Boolean
#   Default Value: true
#   Description: Whether to enable mod_sic
#
# @param enable_mod_stun_disco
#   Type: Boolean
#   Default Value: true
#   Description: Whether to enable mod_stun_disco
#
# @param mod_muc_users_acl
#   Type: Variant[String]
#   Default Value: ""
#   Description: users or user lists allowed to access multi user chats
#
# @param mod_muc_admin_acl
#   Type: Variant[String]
#   Default Value: ""
#   Description: users or user lists allowed to admin multi user chats
#
# @param mod_muc_create_acl
#   Type: Variant[String]
#   Default Value: ""
#   Description: users or user lists allowed to create multi user chats
#
# @param mod_muc_persistent_acl
#   Type: Variant[String]
#   Default Value: ""
#   Description: users or user lists allowed to admin persistent rooms
#
# @param mod_muc_mam_acl
#   Type: Variant[String]
#   Default Value: ""
#   Description: users or user lists allowed to access multi user chats
#
# @param mod_muc_default_room_mam
#   Type: Boolean
#   Default Value: true
#   Description: Whether to enable message archiving
#
# @param disable_s2s
#   Type: Boolean
#   Default Value: false
#   Description: Whether to disable server to server communications
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
  Enum['puppet','hiera','none']                               $templatestorage                  = $ejabberd::params::templatestorage,
  String                                                      $ejabberd_group                   = $ejabberd::params::ejabberd_group,
  String                                                      $log_level                        = $ejabberd::params::log_level,
  Optional[Integer]                                           $log_rotate_count                 = $ejabberd::params::log_rotate_count,
  Variant[Array[String], String]                              $domains                          = $ejabberd::params::domains,
  Variant[Array[String], String]                              $tls_options                      = $ejabberd::params::tls_options,
  String                                                      $servercertfile                   = $ejabberd::params::servercertfile,
  Enum['anonymous','external','internal','ldap','odbc','pam'] $auth_method                      = $ejabberd::params::auth_method,
  Ejabberd::AuthStruct                                        $auth_attrs                       = $ejabberd::params::auth_attrs,
  Enum['mssql', 'mysql', 'postgresql', 'mnesia']              $db_backend                       = $ejabberd::params::db_backend,
  String                                                      $db_params                        = $ejabberd::params::db_params,
  String                                                      $package_ensure                   = $ejabberd::params::package_ensure,
  String                                                      $service_ensure                   = $ejabberd::params::service_ensure,
  Boolean                                                     $service_enable                   = $ejabberd::params::service_enable,
  String                                                      $service_flags                    = $ejabberd::params::service_flags,
  Boolean                                                     $enable_stun                      = $ejabberd::params::enable_stun,
  String                                                      $language                         = $ejabberd::params::language,
  Hash                                                        $transports                       = $ejabberd::params::transports,
  Boolean                                                     $enable_firewall_rules            = $ejabberd::params::enable_firewall_rules,
  Array                                                       $ejabberd_allowed_clients         = $ejabberd::params::ejabberd_allowed_clients,
  Integer                                                     $ejabberd_firewall_rule_order     = $ejabberd::params::ejabberd_firewall_rule_order,
  Integer                                                     $ejabberd_port                    = $ejabberd::params::ejabberd_port,
  Integer                                                     $ejabberd_xmpp_port               = $ejabberd::params::ejabberd_xmpp_port,
  Integer                                                     $ejabberd_xmpps_port              = $ejabberd::params::ejabberd_xmpps_port,
  Integer                                                     $ejabberd_xmpp_s2s_port           = $ejabberd::params::ejabberd_xmpp_s2s_port,
  Integer                                                     $ejabberd_xmpp_admin_ui_port      = $ejabberd::params::ejabberd_xmpp_admin_ui_port,
  Integer                                                     $ejabberd_mqtt_port               = $ejabberd::params::ejabberd_mqtt_port,
  Integer                                                     $ejabberd_stun_port               = $ejabberd::params::ejabberd_stun_port,
  Boolean                                                     $enable_mod_register              = $ejabberd::params::enable_mod_register,
  Boolean                                                     $enable_mod_register_web          = $ejabberd::params::enable_mod_register_web,
  String                                                      $mod_register_ips_allowed         = $ejabberd::params::mod_register_ips_allowed,
  String                                                      $mod_register_welcome_msg_subject = $ejabberd::params::mod_register_welcome_msg_subject,
  String                                                      $mod_register_welcome_msg_body    = $ejabberd::params::mod_register_welcome_msg_body,
  Boolean                                                     $enable_mod_proxy65               = $ejabberd::params::enable_mod_proxy65,
  String                                                      $mod_proxy65_access               = $ejabberd::params::mod_proxy65_access,
  Integer                                                     $mod_proxy65_connections          = $ejabberd::params::mod_proxy65_connections,
  Boolean                                                     $enable_mod_ping                  = $ejabberd::params::enable_mod_ping,
  Integer                                                     $mod_ping_ack_timeout             = $ejabberd::params::mod_ping_ack_timeout,
  Integer                                                     $mod_ping_interval                = $ejabberd::params::mod_ping_interval,
  Enum['none','kill']                                         $mod_ping_timeout_action          = $ejabberd::params::mod_ping_timeout_action,
  Boolean                                                     $enable_mod_version               = $ejabberd::params::enable_mod_version,
  Boolean                                                     $enable_mod_vcard                 = $ejabberd::params::enable_mod_vcard,
  Boolean                                                     $mod_vcard_search_enable          = $ejabberd::params::mod_vcard_search_enable,
  Boolean                                                     $mod_vcard_xupdate_enable         = $ejabberd::params::mod_vcard_xupdate_enable,
  Boolean                                                     $enable_mod_avatar                = $ejabberd::params::enable_mod_avatar,
  Variant[Array[String], String]                              $admin_users                      = $ejabberd::params::admin_users,
  Boolean                                                     $enable_mod_webpresence           = $ejabberd::params::enable_mod_webpresence,
  Boolean                                                     $enable_mod_pottymouth            = $ejabberd::params::enable_mod_pottymouth,
  Boolean                                                     $enable_mod_s2s_log               = $ejabberd::params::enable_mod_s2s_log,
  Boolean                                                     $enable_mod_muc_log_http          = $ejabberd::params::enable_mod_muc_log_http,
  Boolean                                                     $enable_mod_pres_counter          = $ejabberd::params::enable_mod_pres_counter,
  Integer                                                     $mod_pres_counter_count           = $ejabberd::params::mod_pres_counter_count,
  Integer                                                     $mod_pres_counter_interval        = $ejabberd::params::mod_pres_counter_interval,
  Boolean                                                     $enable_mod_adhoc                 = $ejabberd::params::enable_mod_adhoc,
  Boolean                                                     $enable_mod_admin_extra           = $ejabberd::params::enable_mod_admin_extra,
  Boolean                                                     $enable_mod_blocking              = $ejabberd::params::enable_mod_blocking,
  Boolean                                                     $enable_mod_bosh                  = $ejabberd::params::enable_mod_bosh,
  Boolean                                                     $enable_mod_caps                  = $ejabberd::params::enable_mod_caps,
  Boolean                                                     $enable_mod_carboncopy            = $ejabberd::params::enable_mod_carboncopy,
  Boolean                                                     $enable_mod_client_state          = $ejabberd::params::enable_mod_client_state,
  Boolean                                                     $enable_mod_configure             = $ejabberd::params::enable_mod_configure,
  Boolean                                                     $enable_mod_delegation            = $ejabberd::params::enable_mod_delegation,
  Boolean                                                     $enable_mod_disco                 = $ejabberd::params::enable_mod_disco,
  Boolean                                                     $enable_mod_fail2ban              = $ejabberd::params::enable_mod_fail2ban,
  Boolean                                                     $enable_mod_http_api              = $ejabberd::params::enable_mod_http_api,
  Boolean                                                     $enable_mod_last                  = $ejabberd::params::enable_mod_last,
  Boolean                                                     $enable_mod_mqtt                  = $ejabberd::params::enable_mod_mqtt,
  Boolean                                                     $enable_mod_muc_admin             = $ejabberd::params::enable_mod_muc_admin,
  Boolean                                                     $enable_mod_privacy               = $ejabberd::params::enable_mod_privacy,
  Boolean                                                     $enable_mod_private               = $ejabberd::params::enable_mod_private,
  Boolean                                                     $enable_mod_push                  = $ejabberd::params::enable_mod_push,
  Boolean                                                     $enable_mod_push_keepalive        = $ejabberd::params::enable_mod_push_keepalive,
  Boolean                                                     $enable_mod_s2s_dialback          = $ejabberd::params::enable_mod_s2s_dialback,
  Boolean                                                     $enable_mod_shared_roster         = $ejabberd::params::enable_mod_shared_roster,
  Boolean                                                     $enable_mod_sic                   = $ejabberd::params::enable_mod_sic,
  Boolean                                                     $enable_mod_stun_disco            = $ejabberd::params::enable_mod_stun_disco,
  String                                                      $mod_muc_users_acl                = $ejabberd::params::mod_muc_users_acl,
  String                                                      $mod_muc_admin_acl                = $ejabberd::params::mod_muc_admin_acl,
  String                                                      $mod_muc_create_acl               = $ejabberd::params::mod_muc_create_acl,
  String                                                      $mod_muc_persistent_acl           = $ejabberd::params::mod_muc_persistent_acl,
  String                                                      $mod_muc_mam_acl                  = $ejabberd::params::mod_muc_mam_acl,
  Boolean                                                     $mod_muc_default_room_mam         = $ejabberd::params::mod_muc_default_room_mam,
  Boolean                                                     $disable_s2s                      = $ejabberd::params::disable_s2s,
) inherits ejabberd::params {
  class { 'ejabberd::install':
    package_ensure   => $package_ensure,
  }

  class { 'ejabberd::config':
    ejabberd_group                   => $ejabberd_group,
    log_level                        => $log_level,
    log_rotate_count                 => $log_rotate_count,
    domains                          => $domains,
    tls_options                      => $tls_options,
    servercertfile                   => $servercertfile,
    auth_method                      => $auth_method,
    auth_attrs                       => $auth_attrs,
    db_backend                       => $db_backend,
    db_params                        => $db_params,
    enable_stun                      => $enable_stun,
    language                         => $language,
    transports                       => $transports,
    enable_mod_register              => $enable_mod_register,
    enable_mod_register_web          => $enable_mod_register_web,
    mod_register_ips_allowed         => $mod_register_ips_allowed,
    mod_register_welcome_msg_subject => $mod_register_welcome_msg_subject,
    mod_register_welcome_msg_body    => $mod_register_welcome_msg_body,
    enable_mod_proxy65               => $enable_mod_proxy65,
    mod_proxy65_access               => $mod_proxy65_access,
    mod_proxy65_connections          => $mod_proxy65_connections,
    enable_mod_ping                  => $enable_mod_ping,
    mod_ping_ack_timeout             => $mod_ping_ack_timeout,
    mod_ping_interval                => $mod_ping_interval,
    mod_ping_timeout_action          => $mod_ping_timeout_action,
    enable_mod_version               => $enable_mod_version,
    enable_mod_vcard                 => $enable_mod_vcard,
    mod_vcard_search_enable          => $mod_vcard_search_enable,
    mod_vcard_xupdate_enable         => $mod_vcard_xupdate_enable,
    enable_mod_avatar                => $enable_mod_avatar,
    admin_users                      => $admin_users,
    enable_mod_webpresence           => $enable_mod_webpresence,
    enable_mod_pottymouth            => $enable_mod_pottymouth,
    enable_mod_s2s_log               => $enable_mod_s2s_log,
    enable_mod_muc_log_http          => $enable_mod_muc_log_http,
    enable_mod_pres_counter          => $enable_mod_pres_counter,
    mod_pres_counter_count           => $mod_pres_counter_count,
    mod_pres_counter_interval        => $mod_pres_counter_interval,
    enable_mod_adhoc                 => $enable_mod_adhoc,
    enable_mod_admin_extra           => $enable_mod_admin_extra,
    enable_mod_blocking              => $enable_mod_blocking,
    enable_mod_bosh                  => $enable_mod_bosh,
    enable_mod_caps                  => $enable_mod_caps,
    enable_mod_carboncopy            => $enable_mod_carboncopy,
    enable_mod_client_state          => $enable_mod_client_state,
    enable_mod_configure             => $enable_mod_configure,
    enable_mod_delegation            => $enable_mod_delegation,
    enable_mod_disco                 => $enable_mod_disco,
    enable_mod_fail2ban              => $enable_mod_fail2ban,
    enable_mod_http_api              => $enable_mod_http_api,
    enable_mod_last                  => $enable_mod_last,
    enable_mod_mqtt                  => $enable_mod_mqtt,
    enable_mod_muc_admin             => $enable_mod_muc_admin,
    enable_mod_privacy               => $enable_mod_privacy,
    enable_mod_private               => $enable_mod_private,
    enable_mod_push                  => $enable_mod_push,
    enable_mod_push_keepalive        => $enable_mod_push_keepalive,
    enable_mod_s2s_dialback          => $enable_mod_s2s_dialback,
    enable_mod_shared_roster         => $enable_mod_shared_roster,
    enable_mod_sic                   => $enable_mod_sic,
    enable_mod_stun_disco            => $enable_mod_stun_disco,
    mod_muc_users_acl                => $mod_muc_users_acl,
    mod_muc_admin_acl                => $mod_muc_admin_acl,
    mod_muc_create_acl               => $mod_muc_create_acl,
    mod_muc_persistent_acl           => $mod_muc_persistent_acl,
    mod_muc_mam_acl                  => $mod_muc_mam_acl,
    mod_muc_default_room_mam         => $mod_muc_default_room_mam,
    disable_s2s                      => $disable_s2s,
  }

  class { 'ejabberd::certificate':
    ejabberd_group  => $ejabberd_group,
    servercertfile  => $servercertfile,
    templatestorage => $templatestorage,
  }

  class { 'ejabberd::firewall':
    enable                       => $enable_firewall_rules,
    disable_s2s                  => $disable_s2s,
    ejabberd_allowed_clients     => $ejabberd_allowed_clients,
    ejabberd_firewall_rule_order => $ejabberd_firewall_rule_order,
    ejabberd_port                => $ejabberd_port,
    ejabberd_xmpp_port           => $ejabberd_xmpp_port,
    ejabberd_xmpps_port          => $ejabberd_xmpps_port,
    ejabberd_xmpp_s2s_port       => $ejabberd_xmpp_s2s_port,
    ejabberd_xmpp_admin_ui_port  => $ejabberd_xmpp_admin_ui_port,
    ejabberd_mqtt_port           => $ejabberd_mqtt_port,
    enable_stun_firewall         => $enable_stun,
    ejabberd_stun_port           => $ejabberd_stun_port,
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
