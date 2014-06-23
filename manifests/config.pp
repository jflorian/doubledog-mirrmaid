# modules/mirrmaid/manifests/config.pp
#
# == Define: mirrmaid::config
#
# Installs a configuration file for mirrmaid.
#
# === Parameters
#
# [*namevar*]
#   Instance name for the config file, resulting in:
#   /etc/mirrmaid/${name}.conf
#
# [*ensure*]
#   Instance is to be 'present' (default) or 'absent'.
#
# [*source*]
#   URI of the config file content.
#
# [*cronjob*]
#   URI of the cron job file to be installed.  Use the default (undef) if you
#   do not want a cron job file installed.  See the cron::jobfile definition
#   for more details regarding format, requirements, etc.
#
# === Authors
#
#   John Florian <john.florian@dart.biz>
#   John Florian <jflorian@doubledog.org>


define mirrmaid::config (
        $ensure='present',
        $source,
        $cronjob=undef,
    ) {

    include 'cron::daemon'
    include 'mirrmaid::params'

    file { "/etc/mirrmaid/${name}.conf":
        ensure      => $ensure,
        owner       => 'root',
        group       => 'mirrmaid',
        mode        => '0640',
        seluser     => 'system_u',
        selrole     => 'object_r',
        seltype     => 'etc_t',
        subscribe   => Package[$mirrmaid::params::packages],
        source      => "${source}",
    }

    if $cronjob != undef {

        cron::jobfile { "${name}":
            require => Class['mirrmaid'],
            source  => "${cronjob}",
        }

    }

}
