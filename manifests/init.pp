# modules/mirrmaid/manifests/init.pp
#
# == Class: mirrmaid
#
# Configures a host for running mirrmaid.
#
# === Parameters
#
# [*config_uri*]
#   URI of the mirrmaid configuration source.
#
# [*cron_uri*]
#   URI of the cron job configuration source.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>


class mirrmaid ($config_uri, $cron_uri) {

    include 'cron::daemon'

    package { 'mirrmaid':
        ensure	=> installed,
    }

    file { '/etc/mirrmaid/mirrmaid.conf':
        owner   => 'root',
        group	=> 'mirrmaid',
        mode    => '0640',
        seluser => 'system_u',
        selrole => 'object_r',
        seltype => 'etc_t',
        require => Package['mirrmaid'],
        source  => "${config_uri}",
    }

    cron::jobfile { 'mirrmaid':
        require => [
            File['/etc/mirrmaid/mirrmaid.conf'],
            Package['mirrmaid'],
        ],
        source  => "${cron_uri}",
    }

}
