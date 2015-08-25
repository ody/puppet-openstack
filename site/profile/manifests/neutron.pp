##
#
class profile::neutron {

  $rabbit_passwd   = hiera('profile::rabbitmq::passwd')
  $db_passwd       = hiera('profile::mysql::passwd')
  $nova_passwd     = hiera('profile::nova::passwd')
  $keystone_passwd = hiera('profile::keystone::passwd')

  class { '::neutron':
    allow_overlapping_ips => true,
    rabbit_user           => 'neutron',
    rabbit_password       => $rabbit_passwd,
  }

  class { '::neutron::server':
    database_connection => "mysql://neutron:${db_passwd}@127.0.0.1/neutron",
    auth_password       => $keystone_passwd,
    identity_uri        => "http://${facts['networking']['ip']}:35357",
    sync_db             => true,
  }

  class { '::neutron::server::notifications':
    nova_admin_password => $nova_passwd,
    nova_region_name    => 'us-test-1',
  }

  class { '::neutron::agents::dhcp': }
  class { '::neutron::agents::l3': }

  class { '::neutron::agents::ml2::ovs':
    local_ip         => $facts['networking']['interfaces']['ens33']['ip'],
    enable_tunneling => true,
  }

  class { '::neutron::plugins::ml2':
    type_drivers         => ['vxlan'],
    tenant_network_types => ['vxlan'],
    vxlan_group          => '239.1.1.1',
    mechanism_drivers    => ['openvswitch'],
    vni_ranges           => ['0:300']
  }
}
