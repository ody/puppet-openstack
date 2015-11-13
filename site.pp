node 'control1.localdomain' {

  include('::role::openstack::controller')
}

node /compute[0-9]\.localdomain/ {

  include('::role::openstack::compute')
}

node 'master1.localdomain' {

  include('::role::puppet::master')
}
