##
#
class role::openstack::compute {

  include(['::profile::common', '::profile::nova::compute'])

  Class['::profile::common'] -> Class['::profile::nova::compute']
}
