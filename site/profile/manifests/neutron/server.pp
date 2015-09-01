##
#
class profile::neutron::server {

  include('::profile::neutron')

  include('::neutron::client')
  include('::neutron::quota')
  include('::neutron::agents::dhcp')
  include('::neutron::agents::l3')

  Class['::profile::neutron'] -> Class['::profile::neutron::server']

  $db_passwd       = hiera('profile::mysql::passwd')
  $keystone_passwd = hiera('profile::keystone::passwd')

  class { '::neutron::server':
    database_connection => "mysql://neutron:${db_passwd}@127.0.0.1/neutron",
    auth_password       => $keystone_passwd,
    identity_uri        => "http://${facts['networking']['ip']}:35357",
    sync_db             => true,
  }

  class { '::neutron::agents::lbaas':
    device_driver => 'neutron_lbaas.services.loadbalancer.drivers.haproxy.namespace_driver.HaproxyNSDriver',
  }

  class { '::neutron::agents::ml2::ovs':
    enable_tunneling => true,
    local_ip         => $facts['networking']['interfaces']['ens33']['ip'],
    tunnel_types     => ['vxlan'],
    bridge_mappings  => ['external:br-ex'],
    bridge_uplinks   => ['ens34'],
  }

  class { '::neutron::server::notifications':
    nova_admin_password    => $keystone_passwd,
    nova_region_name       => 'us-test-1',
    nova_admin_auth_url    => "http://${facts['networking']['ip']}:35357/v2.0",
    nova_admin_tenant_name => 'openstack',
    nova_admin_username    => 'admin',
  }
}
