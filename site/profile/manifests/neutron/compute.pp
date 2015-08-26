##
#
class profile::neutron::compute {

  $rabbit_passwd   = hiera('profile::rabbitmq::passwd')

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

  class { '::neutron::agents::ml2::ovs':
    enable_tunneling => true,
    local_ip         => $facts['networking']['interfaces']['ens33']['ip'],
    tunnel_types     => ['vxlan'],
  }

  class { '::neutron::plugins::ml2':
    type_drivers         => ['vxlan'],
    tenant_network_types => ['vxlan'],
    mechanism_drivers    => ['openvswitch']
  }
}
