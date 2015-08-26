##
#
class profile::rabbitmq($passwd) {

  class { '::rabbitmq':
    delete_guest_user => true,
    package_provider  => 'yum',
  }

  firewall { '100 allow rabbitmq access':
    dport  => ['5672'],
    proto  => tcp,
    action => accept,
  }

  rabbitmq_vhost { '/':
    provider => 'rabbitmqctl',
    require  => Class['rabbitmq'],
  }

  rabbitmq_user { ['nova', 'keystone', 'neutron']:
    admin    => true,
    password => $passwd,
    provider => 'rabbitmqctl',
    require  => Class['rabbitmq'],
  }

  rabbitmq_user_permissions { ['nova@/', 'keystone@/', 'neutron@/']:
    configure_permission => '.*',
    write_permission     => '.*',
    read_permission      => '.*',
    provider             => 'rabbitmqctl',
    require              => Class['rabbitmq'],
  }
}
