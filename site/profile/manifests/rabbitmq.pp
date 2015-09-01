##
#
class profile::rabbitmq($passwd) {

  class { '::rabbitmq':
    delete_guest_user => true,
    package_provider  => 'yum',
  }

  firewall { '100 allow rabbitmq access':
    dport  => ['5672'],
    proto  => 'tcp',
    action => accept,
  }

  rabbitmq_vhost { '/':
    ensure  => present,
    require => Class['rabbitmq'],
  }

  rabbitmq_user { ['nova', 'keystone', 'neutron']:
    password => $passwd,
    require  => Class['rabbitmq'],
  }

  rabbitmq_user_permissions { ['nova@/', 'keystone@/', 'neutron@/']:
    configure_permission => '.*',
    write_permission     => '.*',
    read_permission      => '.*',
    require              => Class['rabbitmq'],
  }
}
