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
    identity_uri        => "http://${facts['networking']['interfaces']['ens33']['ip']}:5000",
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
    bridge_uplinks   => ['br-ex:ens36'],
  }

  class { '::neutron::server::notifications':
    nova_admin_password => $keystone_passwd,
    nova_region_name    => 'us-test-1',
    nova_admin_auth_url => "http://${facts['networking']['interfaces']['ens34']['ip']}:35357/v2.0",
  }

  class { '::neutron::agents::metadata':
    auth_password => $keystone_passwd,
    shared_secret => 'oUnXsYfhEsY6TppbKj7C2K8oYfWp9yvR',
    enabled       => true,
    auth_url      => "http://${facts['networking']['interfaces']['ens34']['ip']}:35357/v2.0",
    auth_region   => 'us-test-1',
  }


  firewall { '100 allow neutron access':
    dport  => ['9696'],
    proto  => 'tcp',
    action => accept,
  }

  sysctl::value { 'net.ipv4.ip_forward':             value => '1' }
  sysctl::value { 'net.ipv4.conf.all.rp_filter':     value => '0' }
  sysctl::value { 'net.ipv4.conf.default.rp_filter': value => '0' }
}
