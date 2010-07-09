# /etc/puppet/modules/mirrmaid/manifests/init.pp

class mirrmaid {

    package { "mirrmaid":
	ensure	=> installed,
        # These requirements are here to ensure that the pre-install scripts
        # in the mirrmaid package will be able to successfully recognize that
        # a mirrmaid user and group already exist ... in LDAP.  It is
        # essential to do so, otherwise local accounts will be created and
        # that will lead to a situation where everything looks perfect, yet
        # mirrmaid will be denied write access to its targets.
        require => [
            Exec["authconfig"],
            Service["autofs"],
        ],
    }

    file { "/etc/mirrmaid/mirrmaid.conf":
        group	=> "mirrmaid",
        mode    => "0640",
        owner   => "root",
        require => Package["mirrmaid"],
        source  => "puppet:///modules/mirrmaid/mirrmaid.conf",
    }


}
