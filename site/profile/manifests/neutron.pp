##
#
class profile::neutron {

  $rabbit_passwd   = hiera('profile::rabbitmq::passwd')
  $db_passwd       = hiera('profile::mysql::passwd')
  $keystone_passwd = hiera('profile::keystone::passwd')

  class { '::neutron':
    rabbit_user           => 'neutron',
    rabbit_password       => $rabbit_passwd,
    allow_overlapping_ips => true,
    core_plugin           => 'ml2',
    service_plugins       => [
      'neutron.services.l3_router.l3_router_plugin.L3RouterPlugin',
      'neutron.services.loadbalancer.plugin.LoadBalancerPlugin',
      'neutron.services.metering.metering_plugin.MeteringPlugin',
    ],
  }

  class { '::neutron::server':
    database_connection => "mysql://neutron:${db_passwd}@127.0.0.1/neutron",
    auth_password       => $keystone_passwd,
    identity_uri        => "http://${facts['networking']['ip']}:35357",
    sync_db             => true,
  }

  class { '::neutron::client': }
  class { '::neutron::quota': }
  class { '::neutron::agents::dhcp': }
  class { '::neutron::agents::l3': }
  class { '::neutron::agents::lbaas':
    device_driver => 'neutron_lbaas.services.loadbalancer.drivers.haproxy.namespace_driver.HaproxyNSDriver',
  }

  class { '::neutron::agents::ml2::ovs':
    enable_tunneling => true,
    local_ip         => $facts['networking']['interfaces']['ens33']['ip'],
    tunnel_types     => ['vxlan'],
    bridge_mappings  => ['external:br-ex'],
  }
  class { '::neutron::plugins::ml2':
    type_drivers         => ['vxlan'],
    tenant_network_types => ['vxlan'],
    mechanism_drivers    => ['openvswitch']
  }

  class { '::neutron::server::notifications':
    nova_admin_password    => $keystone_passwd,
    nova_region_name       => 'us-test-1',
    nova_admin_auth_url    => "http://${facts['networking']['ip']}:35357/v2.0",
    nova_admin_tenant_name => 'openstack',
    nova_admin_username    => 'admin',
  }
}
