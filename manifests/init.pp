# modules/mirrmaid/manifests/init.pp
#
# == Class: mirrmaid
#
# Manages the mirrmaid service.
#
# === Parameters
#
# ==== Required
#
# ==== Optional
#
# [*ensure*]
#   Instance is to be 'installed' (default), 'latest' or 'absent'.
#
# === Notes
#
#   You will need to configure mirrmaid with one or more configuration files
#   via the ::mirrmaid::config definition.
#
# === Authors
#
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# Copyright 2010-2015 John Florian


class mirrmaid (
        $ensure='installed',
    ) inherits ::mirrmaid::params {

    package { $::mirrmaid::params::packages:
        ensure => $ensure,
    }

}
