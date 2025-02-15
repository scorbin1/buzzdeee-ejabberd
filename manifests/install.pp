# @api private
#
# !!DO NOT CALL THIS CLASS DIRECTLY!!
# Called by ejabberd::init
#
# @summary installs ejabberd package
#
#
class ejabberd::install (
  $package_ensure,
) {
  package { 'ejabberd':
    ensure => $package_ensure,
  }
}
