##
#
class profile::neutron::compute {

  include('::profile::neutron')

  Class['::profile::neutron'] -> Class['::profile::neutron::compute']

  class { '::neutron::agents::ml2::ovs':
    enable_tunneling => true,
    local_ip         => $facts['networking']['interfaces']['ens33']['ip'],
    tunnel_types     => ['vxlan'],
  }
}
