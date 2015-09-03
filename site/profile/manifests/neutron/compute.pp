##
#
class profile::neutron::compute {

  include('::profile::neutron')

  Class['::profile::neutron'] -> Class['::profile::neutron::compute']

  class { '::neutron::agents::ml2::ovs':
    enable_tunneling => true,
    local_ip         => $facts['networking']['interfaces']['ens33']['ip'],
    tunnel_types     => ['gre'],
  }

  sysctl::value { 'net.ipv4.conf.all.rp_filter':     value => '0' }
  sysctl::value { 'net.ipv4.conf.default.rp_filter': value => '0' }
}
