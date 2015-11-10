##
#
class profile::nova {

  $rabbit_passwd   = hiera('profile::rabbitmq::passwd')
  $db_passwd       = hiera('profile::mysql::passwd')

  class { '::nova':
    database_connection => "mysql://nova:${db_passwd}@127.0.0.1/nova?charset=utf8",
    rabbit_userid       => 'nova',
    rabbit_password     => $rabbit_passwd,
    rabbit_host         => '192.168.55.3',
    image_service       => 'nova.image.glance.GlanceImageService',
    glance_api_servers  => '192.168.55.3:9292',
    verbose             => true,
  }
}
