# modules/mirrmaid/manifests/params.pp
#
# == Class: mirrmaid::params
#
# Parameters for the mirrmaid puppet module.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2014-2015 John Florian


class mirrmaid::params {

    case $::operatingsystem {

        'Fedora': {

            $packages = 'mirrmaid'

        }

        default: {
            fail ("${title}: operating system '${::operatingsystem}' is not supported")
        }

    }

}
