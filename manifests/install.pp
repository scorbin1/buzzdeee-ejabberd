# @api private
#
# !!DO NOT CALL THIS CLASS DIRECTLY!!
# Called by ejabberd::init
#
# @summary installs ejabberd package
#
#
# === Parameters
#
# @param package_ensure
#   Type: valid package resource ensure value.  See package resource documentation for
#         more information
#   Default Value: defined by calling class
#   Description: Package version or any other value acceptable by the ensure attribute
#                of a package resource
#
class ejabberd::install (
  String $package_ensure,
) {
  package { 'ejabberd':
    ensure => $package_ensure,
  }

  if $ejabberd::enable_mod_muc_log_http {
    package { 'ejabberd-mod-muc-log-http':
      ensure => $package_ensure,
    }
  }

  if $ejabberd::enable_mod_pottymouth {
    package { 'ejabberd-mod-pottymouth':
      ensure => $package_ensure,
    }
  }

  if $ejabberd::enable_mod_s2s_log {
    package { 'ejabberd-mod-s2s-log':
      ensure => $package_ensure,
    }
  }

  if $ejabberd::enable_mod_webpresence {
    package { 'ejabberd-mod-webpresence':
      ensure => $package_ensure,
    }
  }
}
