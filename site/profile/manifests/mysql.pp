##
#
class profile::mysql($passwd) {

  include('::mysql::server')

  class {
    default:
      password => $passwd,
    ;
    [
      '::glance::db::mysql', '::keystone::db::mysql',
      '::nova::db::mysql', '::neutron::db::mysql'
    ]:
    ;
  }
}
