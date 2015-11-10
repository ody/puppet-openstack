##
#
class profile::nova::compute {

  $rabbit_passwd = hiera('profile::rabbitmq::passwd')

  include('::profile::nova')

  class { '::nova::compute':
    vnc_enabled => true,
    virtio_nic  => true,
    enabled     => true,
  }

  include('::nova::compute::neutron')
  class { '::nova::compute::libvirt':
    migration_support => true,
    vncserver_listen  => '0.0.0.0',
  }

  class { '::nova::network::neutron':
    neutron_admin_password => 'ezxMTZZiqUBWBbdjaW3sqAvHUFs7',
    neutron_url            => 'http://192.168.55.3:9696',
    neutron_region_name    => 'us-test-1',
    neutron_admin_auth_url => 'http://192.168.77.3:35357/v2.0',
  }
}
