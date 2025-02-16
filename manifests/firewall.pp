# == Class: ejabberd::firewall
#
# Sets up ejabberd firewall rules using the puppetlabs-firewall module
#
# === Parameters
#
# @param enable
#   Type: Boolean
#   Default Value: defined by calling class
#   Description: Whether to enable firewall rule definition or not
#
# @param ejabberd_clients
#   Type: Array
#   Default Value: defined by calling class
#   Description: 
#
# @param ejabberd_firewall_rule_order
#   Type: Integer
#   Default Value: defined by calling class
#   Description: 
#
# @param ejabberd_port
#   Type: Integer
#   Default Value: defined by calling class
#   Description: TCP port for ejabberd
#
# @param ejabberd_xmpp_port
#   Type: Integer
#   Default Value: defined by calling class
#   Description: TCP port for ejabberd xmpp
#
# @param ejabberd_xmpps_port
#   Type: Integer
#   Default Value: defined by calling class
#   Description: TCP port for ejabberd xmpps
#
# @param ejabberd_xmpp_s2s_port
#   Type: Integer
#   Default Value: defined by calling class
#   Description: TCP port for ejabberd xmpp server to server
#
# @param ejabberd_xmpp_admin_ui_port
#   Type: Integer
#   Default Value: defined by calling class
#   Description: TCP port for ejabberd xmpp admin ui
#
# @param ejabberd_mqtt_port
#   Type: Integer
#   Default Value: defined by calling class
#   Description: TCP port for ejabberd mqtt
#
class ejabberd::firewall (
  Boolean $enable,
  Array   $ejabberd_clients,
  Integer $ejabberd_firewall_rule_order,
  Integer $ejabberd_port,
  Integer $ejabberd_xmpp_port,
  Integer $ejabberd_xmpps_port,
  Integer $ejabberd_xmpp_s2s_port,
  Integer $ejabberd_xmpp_admin_ui_port,
  Integer $ejabberd_mqtt_port
) {
  if $enable {
    if defined(Class['Firewall']) {
      ## Setup firewall for ejabberd server

      # ejabberd server - TCP 5443
      firewall { "${ejabberd_firewall_rule_order} traffic to ejabberd server":
        chain  => 'INPUT',
        port   => $ejabberd_port,
        proto  => 'tcp',
        source => $ejabberd_clients,
        jump   => accept,
      }

      # ejabberd - xmpp - TCP 5222
      firewall { "${ejabberd_firewall_rule_order} xmpp traffic to ejabberd":
        chain  => 'INPUT',
        port   => $ejabberd_xmpp_port,
        proto  => 'tcp',
        source => $ejabberd_clients,
        jump   => accept,
      }

      # ejabberd - xmpps - TCP 5223
      firewall { "${ejabberd_firewall_rule_order} xmpps traffic to ejabberd":
        chain  => 'INPUT',
        port   => $ejabberd_xmpps_port,
        proto  => 'tcp',
        source => $ejabberd_clients,
        jump   => accept,
      }

      # ejabberd - xmpp_s2s - TCP 5269
      firewall { "${ejabberd_firewall_rule_order} xmpp_s2s traffic to ejabberd":
        chain  => 'INPUT',
        port   => $ejabberd_xmpp_s2s_port,
        proto  => 'tcp',
        source => $ejabberd_clients,
        jump   => accept,
      }

      # ejabberd - xmpp_admin_ui - TCP 5280
      firewall { "${ejabberd_firewall_rule_order} xmpp_admin_ui traffic to ejabberd":
        chain  => 'INPUT',
        port   => $ejabberd_xmpp_admin_ui_port,
        proto  => 'tcp',
        source => $ejabberd_clients,
        jump   => accept,
      }

      # ejabberd - mqtt - TCP 1883
      firewall { "${ejabberd_firewall_rule_order} mqtt traffic to ejabberd":
        chain  => 'INPUT',
        port   => $ejabberd_mqtt_port,
        proto  => 'tcp',
        source => $ejabberd_clients,
        jump   => accept,
      }
    }
    else {
      warning("\n\nfirewall rules were enabled but firewall is not managed by puppet.\n\n")
    }
  }
}
