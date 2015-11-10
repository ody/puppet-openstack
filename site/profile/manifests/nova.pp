##
#
class profile::nova {

  $rabbit_passwd   = hiera('profile::rabbitmq::passwd')

  class { '::nova':
    rabbit_userid      => 'nova',
    rabbit_password    => $rabbit_passwd,
    rabbit_host        => '192.168.55.3',
    image_service      => 'nova.image.glance.GlanceImageService',
    glance_api_servers => '192.168.55.3:9292',
    verbose            => true,
  }
}
