# @api private
#
# !!DO NOT CALL THIS CLASS DIRECTLY!!
# Resources created by ejabberd::init
#
# @summary # Takes care of configuring external transports.

#
#
# === Parameters
#
# @param port
#   Type: Integer
#   Default Value: defined by calling class
#   Description: Port number
#
# @param hosts
#   Type: String, or Array of Strings
#   Default Value: defined by calling class
#   Description: host, or Array of hosts
#
# @param password
#   Type: String
#   Default Value: defined by calling class
#   Description: password
#
$config_filename           = '/etc/ejabberd/ejabberd.yml'

define ejabberd::transport (
  Integer                        $port,
  Variant[Array[String], String] $hosts,
  String                         $password,
) {
  concat::fragment { "ejabberd-transport-${title}":
    target  => $ejabberd::config_filename,
    content => template('ejabberd/ejabberd-transport.cfg.erb'),
    order   => '10',
  }
}
