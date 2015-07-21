##
#
class profile::glance {

  $db_passwd = hiera('profile::mysql::passwd')
  $ks_passwd = hiera('profile::keystone::passwd')

  include('::glance')
  include('::glance::client')
  include('::glance::backend::file')

  class { '::glance::api':
    database_connection => "mysql://glance:${db_passwd}@127.0.0.1/glance",
    keystone_password   => $ks_passwd,
  }

  class { '::glance::registry':
    database_connection => "mysql://glance:${db_passwd}@127.0.0.1/glance",
    keystone_password   => $ks_passwd,
  }
}
