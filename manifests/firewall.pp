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
# @param ejabberd_allowed_clients
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
  Array   $ejabberd_allowed_clients,
  Integer $ejabberd_firewall_rule_order,
  Integer $ejabberd_port,
  Integer $ejabberd_xmpp_port,
  Integer $ejabberd_xmpps_port,
  Integer $ejabberd_xmpp_s2s_port,
  Integer $ejabberd_xmpp_admin_ui_port,
  Integer $ejabberd_mqtt_port
) {
  if $enable {
    ## Setup firewall for ejabberd server
    each($ejabberd_allowed_clients) |$client| {
      if ( $client == '0.0.0.0/0' ) {
        ## ToDo: Can this be implemented by turning array into comma seperated string instead of individual rules?
        # ejabberd server - TCP 5443
        firewall { "${ejabberd_firewall_rule_order} ejabberd server from ${client}":
          chain   => 'INPUT',
          dport   => $ejabberd_port,
          proto   => 'tcp',
          ctstate => 'NEW',
          jump    => accept,
        }

        # ejabberd - xmpp - TCP 5222
        firewall { "${ejabberd_firewall_rule_order} ejabberd xmpp from ${client}":
          chain   => 'INPUT',
          dport   => $ejabberd_xmpp_port,
          proto   => 'tcp',
          ctstate => 'NEW',
          jump    => accept,
        }

        # ejabberd - xmpps - TCP 5223
        firewall { "${ejabberd_firewall_rule_order} ejabberd xmpps from ${client}":
          chain   => 'INPUT',
          dport   => $ejabberd_xmpps_port,
          proto   => 'tcp',
          ctstate => 'NEW',
          jump    => accept,
        }

        # ejabberd - xmpp_s2s - TCP 5269
        firewall { "${ejabberd_firewall_rule_order} ejabberd xmpp_s2s from ${client}":
          chain   => 'INPUT',
          dport   => $ejabberd_xmpp_s2s_port,
          proto   => 'tcp',
          ctstate => 'NEW',
          jump    => accept,
        }

        # ejabberd - xmpp_admin_ui - TCP 5280
        firewall { "${ejabberd_firewall_rule_order} ejabberd admin ui from ${client}":
          chain   => 'INPUT',
          dport   => $ejabberd_xmpp_admin_ui_port,
          proto   => 'tcp',
          ctstate => 'NEW',
          jump    => accept,
        }

        # ejabberd - mqtt - TCP 1883
        firewall { "${ejabberd_firewall_rule_order} ejabberd mqtt from ${client}":
          chain   => 'INPUT',
          dport   => $ejabberd_mqtt_port,
          proto   => 'tcp',
          ctstate => 'NEW',
          jump    => accept,
        }
      }
      else {
        ## ToDo: Can this be implemented by turning array into comma seperated string instead of individual rules?
        # ejabberd server - TCP 5443
        firewall { "${ejabberd_firewall_rule_order} ejabberd server from ${client}":
          chain   => 'INPUT',
          dport   => $ejabberd_port,
          proto   => 'tcp',
          source  => $client,
          ctstate => 'NEW',
          jump    => accept,
        }

        # ejabberd - xmpp - TCP 5222
        firewall { "${ejabberd_firewall_rule_order} ejabberd xmpp from ${client}":
          chain   => 'INPUT',
          dport   => $ejabberd_xmpp_port,
          proto   => 'tcp',
          source  => $client,
          ctstate => 'NEW',
          jump    => accept,
        }

        # ejabberd - xmpps - TCP 5223
        firewall { "${ejabberd_firewall_rule_order} ejabberd xmpps from ${client}":
          chain   => 'INPUT',
          dport   => $ejabberd_xmpps_port,
          proto   => 'tcp',
          source  => $client,
          ctstate => 'NEW',
          jump    => accept,
        }

        # ejabberd - xmpp_s2s - TCP 5269
        firewall { "${ejabberd_firewall_rule_order} ejabberd xmpp_s2s from ${client}":
          chain   => 'INPUT',
          dport   => $ejabberd_xmpp_s2s_port,
          proto   => 'tcp',
          source  => $client,
          ctstate => 'NEW',
          jump    => accept,
        }

        # ejabberd - xmpp_admin_ui - TCP 5280
        firewall { "${ejabberd_firewall_rule_order} ejabberd admin ui from ${client}":
          chain   => 'INPUT',
          dport   => $ejabberd_xmpp_admin_ui_port,
          proto   => 'tcp',
          source  => $client,
          ctstate => 'NEW',
          jump    => accept,
        }

        # ejabberd - mqtt - TCP 1883
        firewall { "${ejabberd_firewall_rule_order} ejabberd mqtt from ${client}":
          chain   => 'INPUT',
          dport   => $ejabberd_mqtt_port,
          proto   => 'tcp',
          source  => $client,
          ctstate => 'NEW',
          jump    => accept,
        }
      }
    }
  }
}
