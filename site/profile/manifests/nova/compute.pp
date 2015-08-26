##
#
class profile::nova::compute {

  $rabbit_passwd = hiera('profile::rabbitmq::passwd')

  class { '::nova':
    rabbit_userid   => 'nova',
    rabbit_password => $rabbit_passwd,
    rabbit_host     => 'megacon1.localdomain',
    image_service   => 'nova.image.glance.GlanceImageService',
  }

  class { '::nova::compute': vnc_enabled => true, }

  class { '::nova::compute::libvirt':
    migration_support => true,
    vncserver_listen  => '0.0.0.0',
  }
}
