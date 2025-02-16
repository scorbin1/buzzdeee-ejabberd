# == Class: ejabberd
#
# Full description of class ejabberd here.
#
# === Parameters
#
# @param servercertfile
#   Type: String
#   Default Value: '/etc/ejabberd/mycert.pem' from $ejabberd::params::servercertfile
#   Description: The path where the server certificate file already exists or should
#                otherwise be installed, depending on templatestorage parameter value
#
# @param templatestorage
#   Type: Enum['puppet','hiera','none']
#   Default Value: 'puppet' from $ejabberd::params::templatestorage
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
#   Default Value: '_ejabberd' from $ejabberd::params::ejabberd_group
#   Description: The group that should own the server certificate file. User is always root.
#
# @param package_ensure
#   Type: valid package resource ensure value.  See package resource documentation for
#         more information
#   Default Value: 'installed' from ejabberd::params::package_ensure
#   Description: Package version or any other value acceptable by the ensure attribute
#                of a package resource
#
# @param service_ensure
#   Type: String
#   Default Value: defined by calling class
#   Description: Desired ejabberd service resource status. This parameter
#                accepts valid service resource ensure values. See service
#                resource documentation for more information
#
# @param service_enable
#   Type: Boolean
#   Default Value: defined by calling class
#   Description: Whether service should be started on boot
#
# @param service_flags
#   Type: String
#   Default Value: defined by calling class
#   Description: String of parameters to pass to the service when starting
#
# @param log_level
#   Type: String
#   Default Value: defined by calling class
#   Description: Verbosity of log files generated by ejabberd
#
# @param domains
#   Type: Variant[Array[String], String]
#   Default Value: defined by calling class
#   Description: Domains served by ejabberd. Can be a single domain as a String
#                or a list of domains as an array of Strings
#
# @param auth_method
#   Type: Enum['anonymous','external','internal','ldap','odbc','pam']
#   Default Value: defined by calling class
#   Description: Login authentication mechanism to use with ejabberd
#     Acceptable values:
#       'anonymous' - Do not require authentication
#       'external'  - Use external auth mechanism
#       'internal'  - Use ejabberd to authenticate
#       'ldap'      - Use an ldap backend to authenticate users
#       'odbc'      - Use an odbc connection to authenticate users
#       'pam'       - Use pam to authenticate users
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
  Enum['puppet','hiera','none']                               $templatestorage = $ejabberd::params::templatestorage,
  String                                                      $ejabberd_group  = $ejabberd::params::ejabberd_group,
  String                                                      $log_level       = $ejabberd::params::log_level,
  Variant[Array[String], String]                              $domains         = $ejabberd::params::domains,
  String                                                      $servercertfile  = $ejabberd::params::servercertfile,
  Enum['anonymous','external','internal','ldap','odbc','pam'] $auth_method     = $ejabberd::params::auth_method,
  Ejabberd::AuthStruct                                        $auth_attrs      = $ejabberd::params::auth_attrs,
  Enum['mssql', 'mysql', 'postgresql', 'mnesia']              $db_backend      = $ejabberd::params::db_backend,
  String                                                      $db_params       = $ejabberd::params::db_params,
  String                                                      $package_ensure  = $ejabberd::params::package_ensure,
  String                                                      $service_ensure  = $ejabberd::params::service_ensure,
  Boolean                                                     $service_enable  = $ejabberd::params::service_enable,
  String                                                      $service_flags   = $ejabberd::params::service_flags,
  Boolean                                                     $enable_stun     = $ejabberd::params::enable_stun,
  String                                                      $language        = $ejabberd::params::language,
  Hash                                                        $transports      = $ejabberd::params::transports,
) inherits ejabberd::params {
  class { 'ejabberd::install':
    package_ensure   => $package_ensure,
  }

  class { 'ejabberd::config':
    ejabberd_group => $ejabberd_group,
    log_level      => $log_level,
    domains        => $domains,
    servercertfile => $servercertfile,
    auth_method    => $auth_method,
    auth_attrs     => $auth_attrs,
    db_backend     => $db_backend,
    db_params      => $db_params,
    enable_stun    => $enable_stun,
    language       => $language,
    transports     => $transports,
  }

  class { 'ejabberd::certificate':
    ejabberd_group  => $ejabberd_group,
    servercertfile  => $servercertfile,
    templatestorage => $templatestorage,
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
