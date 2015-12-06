# modules/mirrmaid/manifests/config.pp
#
# == Define: mirrmaid::config
#
# Manages a configuration file for mirrmaid.
#
# === Parameters
#
# ==== Required
#
# [*namevar*]
#   An arbitrary identifier for the configuration instance unless the
#   "confname" parameter is not set in which case this must provide the value
#   normally set with the "confname" parameter.
#
# ==== Optional
#
# [*ensure*]
#   Instance is to be 'present' (default) or 'absent'.
#
# [*confname*]
#   Name to be given to the configuration file, without path details nor
#   suffix.  This may be used in place of "namevar" if it's beneficial to give
#   namevar an arbitrary value.
#
#   This will result in a configuration file named:
#       /etc/mirrmaid/${confname}.conf
#
#
# [*content*]
#   Literal content for the configuration file.  If neither "content" nor
#   "source" is given, the content of the file will be left unmanaged.
#
# [*cronjob*]
#   URI of the cron job file to be installed.  Use the default (undef) if you
#   do not want a cron job file installed.  See the cron::jobfile definition
#   for more details regarding format, requirements, etc.
#
# [*source*]
#   URI of the configuration file content.  If neither "content" nor "source"
#   is given, the content of the file will be left unmanaged.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2014-2015 John Florian


define mirrmaid::config (
        $ensure='present',
        $confname=$title,
        $cronjob=undef,
        $content=undef,
        $source=undef,
    ) {

    require '::mirrmaid'
    include '::mirrmaid::params'

    file { "/etc/mirrmaid/${confname}.conf":
        ensure    => $ensure,
        owner     => 'root',
        group     => 'mirrmaid',
        mode      => '0640',
        seluser   => 'system_u',
        selrole   => 'object_r',
        seltype   => 'etc_t',
        subscribe => Package[$::mirrmaid::params::packages],
        content   => $content,
        source    => $source,
    }

    if $cronjob != undef {

        cron::jobfile { $name:
            ensure  => $ensure,
            require => Class['mirrmaid'],
            source  => $cronjob,
        }

    }

}
