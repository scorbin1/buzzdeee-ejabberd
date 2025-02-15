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
class ejabberd (
  Enum['puppet','hiera','none'] $templatestorage = $ejabberd::params::templatestorage,
  String                        $ejabberd_group  = $ejabberd::params::ejabberd_group,
  $log_level                                     = $ejabberd::params::log_level,
  $domains                                       = $ejabberd::params::domains,
  String                        $servercertfile  = $ejabberd::params::servercertfile,
  $auth_method                                   = $ejabberd::params::auth_method,
  $auth_attrs                                    = $ejabberd::params::auth_attrs,
  $db_backend                                    = $ejabberd::params::db_backend,
  $db_params                                     = $ejabberd::params::db_params,
  String                        $package_ensure  = $ejabberd::params::package_ensure,
  String                        $service_ensure  = $ejabberd::params::service_ensure,
  Boolean                       $service_enable  = $ejabberd::params::service_enable,
  String                        $service_flags   = $ejabberd::params::service_flags,
  $enable_stun                                   = $ejabberd::params::enable_stun,
  $language                                      = $ejabberd::params::language,
  $transports                                    = $ejabberd::params::transports,
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
