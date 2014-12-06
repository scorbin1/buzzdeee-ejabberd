class ejabberd::install (
  $package_ensure,
) {
  package { 'ejabberd':
    ensure => $package_ensure,
  }
}
