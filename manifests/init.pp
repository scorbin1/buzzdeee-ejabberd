# == Class: ejabberd
#
# Full description of class ejabberd here.
#
# === Parameters
#
# Document parameters here.
#
# [*sample_parameter*]
#   Explanation of what this parameter affects and what it defaults to.
#   e.g. "Specify one or more upstream ntp servers as an array."
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# [*sample_variable*]
#   Explanation of how this variable affects the funtion of this class and if
#   it has a default. e.g. "The parameter enc_ntp_servers must be set by the
#   External Node Classifier as a comma separated list of hostnames." (Note,
#   global variables should be avoided in favor of class parameters as
#   of Puppet 2.6.)
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
  $templatestorage = $ejabberd::params::templatestorage,
  $ejabberd_group  = $ejabberd::params::ejabberd_group,
  $log_level       = $ejabberd::params::log_level,
  $domains         = $ejabberd::params::domains,
  $servercertfile  = $ejabberd::params::servercertfile,
  $auth_method     = $ejabberd::params::auth_method,
  $auth_attrs      = $ejabberd::params::auth_attrs,
  $db_backend      = $ejabberd::params::db_backend,
  $db_params       = $ejabberd::params::db_params,
  $package_ensure  = $ejabberd::params::package_ensure,
  $service_ensure  = $ejabberd::params::service_ensure,
  $service_enable  = $ejabberd::params::service_enable,
  $service_flags   = $ejabberd::params::service_flags,
  $enable_stun     = $ejabberd::params::enable_stun,
  $language        = $ejabberd::params::language,
  $transports      = $ejabberd::params::transports,
  $templatestorage = $ejabberd::params::templatestorage,
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

  Class['ejabberd::install'] ->
  Class['ejabberd::certificate'] ~>
  Class['ejabberd::config'] ~>
  Class['ejabberd::service']

}
