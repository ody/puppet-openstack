##
#
class role::openstack::controller {

  include([
    'profile::common',
    'profile::mysql',
    'profile::rabbitmq',
    'profile::keystone',
    'profile::glance',
    'profile::nova::server',
    'profile::neutron::server',
    'profile::puppet',
    'profile::puppet::db',
  ])

  Class[['profile::puppet', 'profile::puppet::db']] -> Class['profile::common'] ->
  Class[['profile::mysql', 'profile::rabbitmq']] ->
  Class['profile::keystone'] -> Class[['profile::glance', 'profile::nova::server']] ->
  Class['profile::neutron::server']
}
