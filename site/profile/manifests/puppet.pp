##
#
class profile::puppet {

  firewall { '100 allow puppetserver access':
    dport  => ['8140'],
    proto  => tcp,
    action => accept,
  }
}
