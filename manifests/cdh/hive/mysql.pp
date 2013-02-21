# == Class: cloudera::cdh::hive::mysql
#
# This class handles creating the Hive Metastore database.
#
# === Parameters:
#
# === Actions:
#
# === Requires:
#
# === Sample Usage:
#
#   class { 'cloudera::cdh::hive::mysql': }
#
# === Authors:
#
# Mike Arnold <mike@razorsedge.org>
#
# === Copyright:
#
# Copyright (C) 2013 Mike Arnold, unless otherwise noted.
#
class cloudera::cdh::hive::mysql (
  $password,
  $database_name = 'metastore_db',
  $username      = 'hive',
  $hive_version  = '0.9.0'
) inherits cloudera::params {
  include mysql::java

  file { '/usr/lib/hive/lib/mysql-connector-java.jar':
    ensure => link,
    target => '/usr/share/java/mysql-connector-java.jar',
  }

  mysql::db { $database_name:
    user     => $username,
    password => $password,
    host     => '%',
    grant    => [ 'select_priv', 'insert_priv', 'update_priv', 'delete_priv', ],
    sql      => "/usr/lib/hive/scripts/metastore/upgrade/mysql/hive-schema-${hive_version}.mysql.sql",
    require  => Class['mysql::config'],
  }
}