#
# == Class: mirrmaid
#
# Manages mirrmaid on a host.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# This file is part of the doubledog-mirrmaid Puppet module.
# Copyright 2010-2018 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later


class mirrmaid (
        Array[String[1], 1]         $packages,
        String[1]                   $ensure,
        Hash[String[1], Hash]       $mirrors,
        Optional[Array[String[1]]]  $rsync_options,
    ) {

    package { $packages:
        ensure => $ensure,
    }

    create_resources(::mirrmaid::mirror, $mirrors)

}
