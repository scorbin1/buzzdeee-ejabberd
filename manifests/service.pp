# Private class, do not use directly.
# Takes care about the service.

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
