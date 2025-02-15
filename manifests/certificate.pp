# @api private
#
# !!DO NOT CALL THIS CLASS DIRECTLY!!
# Called by ejabberd::init
#
# @summary creates/installs ejabberd server certificate
#
#
# === Parameters
#
# @param servercertfile
#   Type: String
#   Default Value: defined by calling class
#   Description: The path where the server certificate file should be installed
#
# @param templatestorage
#   Type: Enum['puppet','hiera','none']
#   Default Value: defined by calling class
#   Description: Define how to source/create certificate file 
#     'puppet' - source certificate file from puppet hosted file ejabberd/ejabberd.pem
#                Bug: This option not working on debian linux.  Likely relative source
#                     paths are deprecated feature
#     'hiera'  - source certificate file via hiera lookup using file name defined in
#                $servercertfile, with file path removed, as the argument to hiera()
#     'none'   - Set to this value if server ssl certificate already exists or is defined
#                externally
#
# @param ejabberd_group
#   Type: String
#   Default Value: defined by calling class
#   Description: The group ownership of the server certificate file.  Owner is always root.
#
class ejabberd::certificate (
  String $servercertfile,
  Enum['puppet','hiera','none'] $templatestorage,
  String $ejabberd_group,
) {
  $templatefile = split($servercertfile, '/')[-1]
  case $templatestorage {
    'puppet': {
      file { $servercertfile:
        owner  => 'root',
        group  => $ejabberd_group,
        mode   => '0640',
        source => 'ejabberd/ejabberd.pem',
      }
    }
    'hiera': {
      file { $servercertfile:
        owner   => 'root',
        group   => $ejabberd_group,
        mode    => '0640',
        content => hiera($templatefile),
      }
    }
    'none': {
      # deliberately do nothing here, it's externally taken care of
    }
    default: { fail("templatestorage must be either 'puppet' or 'hiera'") }
  }
}
