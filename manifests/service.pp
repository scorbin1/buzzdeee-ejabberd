# @api private
#
# !!DO NOT CALL THIS CLASS DIRECTLY!!
# Called by ejabberd::init
#
# @summary Sets up ejabberd service
#
#
# === Parameters
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
class ejabberd::service (
  String  $service_ensure,
  Boolean $service_enable,
  String  $service_flags,
) {
  service { 'ejabberd':
    ensure => $service_ensure,
    enable => $service_enable,
    flags  => $service_flags,
  }
}
