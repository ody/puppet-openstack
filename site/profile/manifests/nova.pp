##
#
class profile::nova {

  $rabbit_passwd   = hiera('profile::rabbitmq::passwd')
  $db_passwd       = hiera('profile::mysql::passwd')
  $keystone_passwd = hiera('profile::keystone::passwd')

  class { '::nova':
    database_connection => "mysql://nova:${db_passwd}@127.0.0.1/nova?charset=utf8",
    rabbit_userid       => 'nova',
    rabbit_password     => $rabbit_passwd,
    image_service       => 'nova.image.glance.GlanceImageService',
    verbose             => true,
  }

  class { '::nova::api':
    admin_password                       => $keystone_passwd,
    auth_uri                             => "http://${facts['networking']['interfaces']['ens33']['ip']}:5000",
    identity_uri                         => "http://${facts['networking']['interfaces']['ens34']['ip']}:35357",
    osapi_v3                             => false,
    enabled                              => true,
    neutron_metadata_proxy_shared_secret => 'oUnXsYfhEsY6TppbKj7C2K8oYfWp9yvR'
  }

  class { '::nova::cert':        enabled => true, }
  class { '::nova::conductor':   enabled => true, }
  class { '::nova::consoleauth': enabled => true, }
  class { '::nova::scheduler':   enabled => true, }
  class { '::nova::vncproxy':    enabled => true, }

  include('::nova::cron::archive_deleted_rows')
  include('::nova::client')

  firewall { '100 allow nova access':
    dport  => ['8774'],
    proto  => 'tcp',
    action => accept,
  }

  class { '::nova::network::neutron':
    neutron_admin_password => $keystone_passwd,
    neutron_url            => 'http://192.168.55.3:9696',
    neutron_region_name    => 'us-test-1',
    neutron_admin_auth_url => 'http://192.168.77.3:35357/v2.0',
  }
}
