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
}
