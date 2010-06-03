# /etc/puppet/modules/mirrmaid/manifests/init.pp

class mirrmaid {

    # TODO: remove this obsoleted package, say after 6/30/2010
    package { "doubledog-mirror-manager":
	ensure	=> absent,
    }

    package { "mirrmaid":
	ensure	=> installed,
    }

    file { "/etc/mirrmaid.conf":
        group	=> "root",
        mode    => 640,
        owner   => "root",
        require => Package["mirrmaid"],
        source  => "puppet:///modules/mirrmaid/mirrmaid.conf",
    }


}
