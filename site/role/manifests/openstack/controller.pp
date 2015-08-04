##
#
class role::openstack::controller {

  include([
    'profile::common',
    'profile::mysql',
    'profile::rabbitmq',
    'profile::keystone',
    'profile::glance',
    'profile::nova',
    'profile::neutron',
    'profile::puppet::db'
  ])

  Class['profile::puppet::db'] -> Class['profile::common'] ->
  Class[['profile::mysql', 'profile::rabbitmq']] ->
  Class['profile::keystone'] -> Class[['profile::glance', 'profile::nova', 'profile::neutron']]
}
