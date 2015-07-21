##
#
class profile::rabbitmq($passwd) {

  class { '::rabbitmq': delete_guest_user => true, }

  rabbitmq_vhost { '/':
    provider => 'rabbitmqctl',
    require  => Class['rabbitmq'],
  }

  rabbitmq_user { ['nova', 'keystone']:
    admin    => true,
    password => $passwd,
    provider => 'rabbitmqctl',
    require  => Class['rabbitmq'],
  }

  rabbitmq_user_permissions { ['nova@/', 'keystone@/']:
    configure_permission => '.*',
    write_permission     => '.*',
    read_permission      => '.*',
    provider             => 'rabbitmqctl',
    require              => Class['rabbitmq'],
  }
}
