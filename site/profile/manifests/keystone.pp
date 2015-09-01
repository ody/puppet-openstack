##
#
class profile::keystone(
  $admin_token,
  $passwd,
) {

  $rabbit_passwd = hiera('profile::rabbitmq::passwd')
  $db_passwd     = hiera('profile::mysql::passwd')

  class { '::openstack_extras::auth_file':
    password    => $passwd,
    region_name => 'us-test-1',
    auth_url    => 'http://127.0.0.1:5000/v2.0/',
    path        => '/root/admin-openrc.sh',
  }

  class { '::keystone':
    database_connection => "mysql://keystone:${db_passwd}@127.0.0.1/keystone",
    admin_token         => $admin_token,
    rabbit_password     => $rabbit_passwd,
    rabbit_userid       => 'keystone',
  }

  include('::keystone::client')
  include('::keystone::cron::token_flush')

  class { '::keystone::endpoint':
    public_url     => "http://${facts['networking']['ip']}:5000",
    admin_url      => "http://${facts['networking']['ip']}:35357",
    internal_url   => "http://${facts['networking']['interfaces']['ens33']['ip']}:5000",
    region         => 'us-test-1',
    default_domain => 'admin',
  }

  class { '::keystone::roles::admin':
    email    => 'admin@example.com',
    password => $passwd,
  }

  class {
    default:
      password => $passwd,
      region   => 'us-test-1',
    ;
    '::nova::keystone::auth':
      public_url   => "http://${facts['networking']['ip']}:8774/v2/%(tenant_id)s",
      admin_url    => "http://${facts['networking']['ip']}:8774/v2/%(tenant_id)s",
      internal_url => "http://${facts['networking']['interfaces']['ens33']['ip']}:8774/v2/%(tenant_id)s",
    ;
    '::glance::keystone::auth':
      public_url   => "http://${facts['networking']['ip']}:9292",
      admin_url    => "http://${facts['networking']['ip']}:9292",
      internal_url => "http://${facts['networking']['interfaces']['ens33']['ip']}:9292",
    ;
    '::neutron::keystone::auth':
      public_url   => "http://${facts['networking']['ip']}:9696",
      admin_url    => "http://${facts['networking']['ip']}:9696",
      internal_url => "http://${facts['networking']['interfaces']['ens33']['ip']}:9696",
    ;
  }

  firewall { '100 allow keystone admin access':
    dport  => ['35357'],
    proto  => 'tcp',
    action => accept,
  }
}
