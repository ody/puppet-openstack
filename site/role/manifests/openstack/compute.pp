##
#
class role::openstack::compute {

  include(['::profile::common', '::profile::nova::compute', '::profile::neutron::compute'])

  Class['::profile::common'] -> Class[['::profile::nova::compute', '::profile::neutron::compute']]
}
