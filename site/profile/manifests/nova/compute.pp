##
#
class profile::nova::compute {

  $rabbit_passwd = heira('profile::rabbitmq::passwd')

  class { '::nova':
    rabbit_userid   => 'nova',
    rabbit_password => $rabbit_passwd,
    image_service   => 'nova.image.glance.GlanceImageService',
  }

  class { '::nova::compute': vnc_enabled => true, }

  class { '::nova::compute::libvirt':
    migration_support => true,
    vncserver_listen  => '0.0.0.0',
  }
}
