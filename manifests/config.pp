# @api private
#
# !!DO NOT CALL THIS CLASS DIRECTLY!!
# Called by ejabberd::init
#
# @summary configures ejabberd.conf file
#
#
# === Parameters
#
# @param log_level
#   Type: String
#   Default Value: defined by calling class
#   Description: Verbosity of log files generated by ejabberd
#     0: No ejabberd log at all (not recommended)
#     1: Critical
#     2: Error
#     3: Warning
#     4: Info
#     5: Debug
#
# @param domains
#   Type: Variant[Array[String], String]
#   Default Value: defined by calling class
#   Description: Domains served by ejabberd. Can be a single domain as a String
#                or a list of domains as an array of Strings
#
# @param servercertfile
#   Type: String
#   Default Value: defined by calling class
#   Description: Path to server certificate file
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
# @param ejabberd_group
#   Type: String
#   Default Value: defined by calling class
#   Description: The group that owns the 
#
class ejabberd::config (
  String                                                      $log_level,
  Variant[Array[String], String]                              $domains,
  String                                                      $servercertfile,
  Enum['anonymous','external','internal','ldap','odbc','pam'] $auth_method,
  Ejabberd::AuthStruct                                        $auth_attrs,
  Hash                                                        $transports,
  Boolean                                                     $enable_stun,
  Enum['mssql','mysql','postgresql','mnesia']                 $db_backend,
  Optional[String]                                            $db_params,
  String                                                      $language,
  String                                                      $ejabberd_group,
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

  concat::fragment { 'ejabberd-header':
    target  => $config_filename,
    content => template("ejabberd/ejabberd-header.cfg${config_set}.erb"),
    order   => '01',
  }

  if $transports {
    create_resources(ejabberd::transport, $transports)
  }

  concat::fragment { 'ejabberd-after-transports':
    target  => $config_filename,
    content => template("ejabberd/ejabberd-after-transports.cfg${config_set}.erb"),
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

  concat::fragment { 'ejabberd-after-database':
    target  => $config_filename,
    content => template("ejabberd/ejabberd-after-dbconfig.cfg${config_set}.erb"),
    order   => '60',
  }

  concat::fragment { 'ejabberd-end':
    target  => $config_filename,
    content => template("ejabberd/ejabberd-end.cfg${config_set}.erb"),
    order   => '70',
  }
}
