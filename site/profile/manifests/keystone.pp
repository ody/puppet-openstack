##
#
class profile::keystone(
  $admin_token,
  $passwd,
) {

  $rabbit_passwd = hiera('profile::rabbitmq::passwd')
  $db_passwd     = hiera('profile::mysql::passwd')

  include('::keystone::client')
  include('::keystone::cron::token_flush')

  class { '::keystone':
    database_connection => "mysql://keystone:${db_passwd}@127.0.0.1/keystone",
    admin_token         => $admin_token,
    rabbit_password     => $rabbit_passwd,
    rabbit_userid       => 'keystone',
  }

  class { '::keystone::endpoint':
    public_url     => "http://${facts['networking']['ip']}:5000",
    admin_url      => "http://${facts['networking']['ip']}:35357",
    internal_url   => "http://${facts['networking']['interfaces']['ens33']['ip']}:5000",
    region         => 'us-test-1',
    default_domain => 'admin',
  }

  keystone_domain { 'admin':
    ensure      => present,
    enabled     => true,
    description => 'Domain for v3 admin users',
  }

  keystone_domain { 'services':
    ensure      => present,
    enabled     => true,
    description => 'Domain for v3 service users',
  }

  keystone_tenant { 'services':
    ensure      => present,
    enabled     => true,
    description => 'Tenant for the openstack services',
    domain      => 'services',
  }

  keystone_tenant { 'openstack':
    ensure      => present,
    enabled     => true,
    description => 'admin tenant',
    domain      => 'admin',
  }

  keystone_user { 'admin':
    ensure   => present,
    enabled  => true,
    tenant   => 'openstack',
    email    => 'admin@example.com',
    password => $passwd,
    domain   => 'admin',
  }

  keystone_user_role { 'admin@openstack':
    ensure => present,
    roles  => ['admin'],
  }

  class {
    default:
      password => $passwd,
      region   => 'us-test-1',
    ;
    '::nova::keystone::auth':
      public_url_v3   => "http://${facts['networking']['ip']}:8774/v3",
      admin_url_v3    => "http://${facts['networking']['ip']}:8774/v3",
      internal_url_v3 => "http://${facts['networking']['interfaces']['ens33']['ip']}:8774/v3",
    ;
    '::glance::keystone::auth':
      public_url_v3   => "http://${facts['networking']['ip']}:9292/v3",
      admin_url_v3    => "http://${facts['networking']['ip']}:9292/v3",
      internal_url_v3 => "http://${facts['networking']['interfaces']['ens33']['ip']}:9292/v3",
    ;
  }

}
