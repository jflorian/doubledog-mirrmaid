# modules/mirrmaid/manifests/init.pp
#
# == Class: mirrmaid
#
# Configures a host for mirrmaid service.
#
# === Parameters
#
# [*ensure*]
#   Instance is to be 'installed' (default), 'latest' or 'absent'.
#
# === Notes
#
#   You will need to configure mirrmaid with one or more configuration files
#   via the mirrmaid::config definition.
#
# === Authors
#
#   John Florian <john.florian@dart.biz>
#   John Florian <john.florian@dart.biz>




class mirrmaid (
        $ensure='installed',
    ) {

    include 'mirrmaid::params'

    package { $mirrmaid::params::packages:
        ensure  => $ensure,
    }

}
