# modules/mirrmaid/manifests/init.pp

class mirrmaid {

    include cron::daemon

    package { 'mirrmaid':
	ensure	=> installed,
        # These requirements are here to ensure that the pre-install scripts
        # in the mirrmaid package will be able to successfully recognize that
        # a mirrmaid user and group already exist ... in LDAP.  It is
        # essential to do so, otherwise local accounts will be created and
        # that will lead to a situation where everything looks perfect, yet
        # mirrmaid will be denied write access to its targets.
        #
        # Unfortunately, my authconfig class is not exactly idempotent and
        # requires at least two catalog applications before things work.
        # Consequently crond may balk at the mirrmaid user given to the cron
        # job and refuse to run it.  A notify to crond might help, but that
        # depends on a race condition; what the hell, can't hurt :(
        notify  => Service['crond'],
        require => [
            Exec['authconfig'],
            Service['autofs'],
        ],
    }

    file { '/etc/mirrmaid/mirrmaid.conf':
        group	=> 'mirrmaid',
        mode    => '0640',
        owner   => 'root',
        require => Package['mirrmaid'],
        source  => 'puppet:///modules/mirrmaid/mirrmaid.conf',
    }

    cron::jobfile { 'mirrmaid':
        require => [
            File['/etc/mirrmaid/mirrmaid.conf'],
            Package['mirrmaid'],
        ],
        source  => 'puppet:///private-host/mirrmaid/mirrmaid.cron',
    }

}
