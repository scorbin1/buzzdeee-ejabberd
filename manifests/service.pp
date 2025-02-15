# @api private
#
# !!DO NOT CALL THIS CLASS DIRECTLY!!
# Called by ejabberd::init
#
# @summary Sets up ejabberd service
#
#
class ejabberd::service (
  $service_ensure,
  $service_enable,
  $service_flags,
) {
  service { 'ejabberd':
    ensure => $service_ensure,
    enable => $service_enable,
    flags  => $service_flags,
  }
}
