##
#
class profile::common {

  include('::epel')
  class { '::openstack_extras::repo::redhat::redhat':
    manage_epel => false,
  }
}
