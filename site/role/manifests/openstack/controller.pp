##
#
class role::openstack::controller {

  include([
    'profile::mysql', 'profile::rabbitmq', 'profile::keystone',
    'profile::glance', 'profile::nova'
  ])

  Class[['profile::mysql', 'profile::rabbitmq']] ->
  Class['profile::keystone'] -> Class[['profile::glance', 'profile::nova']]
}
