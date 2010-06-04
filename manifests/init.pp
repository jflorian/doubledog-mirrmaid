# /etc/puppet/modules/mirrmaid/manifests/init.pp

class mirrmaid {

    package { "mirrmaid":
	ensure	=> installed,
    }

    file { "/etc/mirrmaid/mirrmaid.conf":
        group	=> "root",
        mode    => 640,
        owner   => "root",
        require => Package["mirrmaid"],
        source  => "puppet:///modules/mirrmaid/mirrmaid.conf",
    }


}
