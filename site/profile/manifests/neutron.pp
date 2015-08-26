##
#
class profile::neutron {

  $rabbit_passwd   = hiera('profile::rabbitmq::passwd')

  class { '::neutron':
    rabbit_user           => 'neutron',
    rabbit_password       => $rabbit_passwd,
    rabbit_host           => 'megacon1.localdomain',
    allow_overlapping_ips => true,
    core_plugin           => 'ml2',
    service_plugins       => [
      'neutron.services.l3_router.l3_router_plugin.L3RouterPlugin',
      'neutron.services.loadbalancer.plugin.LoadBalancerPlugin',
      'neutron.services.metering.metering_plugin.MeteringPlugin',
    ],
  }

  class { '::neutron::plugins::ml2':
    type_drivers         => ['vxlan', 'flat'],
    tenant_network_types => ['vxlan'],
    mechanism_drivers    => ['openvswitch']
  }
}
