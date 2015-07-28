##
#
class profile::puppet::db {

  class { '::puppetdb': database => 'embedded', }
  include('::puppetdb::master::config')
}
