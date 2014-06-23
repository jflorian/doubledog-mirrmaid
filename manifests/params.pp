# modules/mirrmaid/manifests/params.pp
#
# == Class: mirrmaid::params
#
# Parameters for the mirrmaid puppet module.
#
# === Authors
#
#   John Florian <john.florian@dart.biz>
#   John Florian <jflorian@doubledog.org>


class mirrmaid::params {

    case $::operatingsystem {
        Fedora: {

            $packages = [
                'mirrmaid',
            ]

        }

        default: {
            fail ("The mirrmaid module is not yet supported on ${::operatingsystem}.")
        }

    }

}
