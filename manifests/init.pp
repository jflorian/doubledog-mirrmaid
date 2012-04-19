# modules/mirrmaid/manifests/init.pp

class mirrmaid {

    include cron::daemon

    package { 'mirrmaid':
	ensure	=> installed,
    }

    file { '/etc/mirrmaid/mirrmaid.conf':
        group	=> 'mirrmaid',
        mode    => '0640',
        owner   => 'root',
        require => Package['mirrmaid'],
        source  => [
            'puppet:///private-host/mirrmaid/mirrmaid.conf',
            'puppet:///private-domain/mirrmaid/mirrmaid.conf',
            'puppet:///modules/mirrmaid/mirrmaid.conf',
        ],
    }

    cron::jobfile { 'mirrmaid':
        require => [
            File['/etc/mirrmaid/mirrmaid.conf'],
            Package['mirrmaid'],
        ],
        source  => 'puppet:///private-host/mirrmaid/mirrmaid.cron',
    }

}
