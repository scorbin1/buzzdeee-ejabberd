# Private class, do not use directly.
# Takes care about the package installation.

class ejabberd::install (
  $package_ensure,
) {
  package { 'ejabberd':
    ensure => $package_ensure,
  }
}
