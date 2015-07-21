##
#
class profile::nova($passwd) {

  $rabbit_passwd = hiera('profile::rabbitmq::passwd')
  $db_passwd     = hiera('profile::mysql::passwd')

  include('::nova::cert')
  include('::nova::conductor')
  include('::nova::consoleauth')
  include('::nova::cron::archive_deleted_rows')
  include('::nova::client')
  include('::nova::scheduler')
  include('::nova::vncproxy')

  class { '::nova':
    database_connection => "mysql://nova:${db_passwd}@127.0.0.1/nova?charset=utf8",
    rabbit_userid       => 'nova',
    rabbit_password     => $rabbit_passwd,
    image_service       => 'nova.image.glance.GlanceImageService',
  }

  class { '::nova::api':
    admin_password => $passwd,
    auth_uri       => "http://${facts['networking']['ip']}:5000",
    identity_uri   => "http://${facts['networking']['ip']}:35357",
    osapi_v3       => true,
  }
}
