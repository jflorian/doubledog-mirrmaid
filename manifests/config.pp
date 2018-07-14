#
# == Define: mirrmaid::config
#
# Manages a configuration file for mirrmaid.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# This file is part of the doubledog-mirrmaid Puppet module.
# Copyright 2014-2018 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later


define mirrmaid::config (
        $ensure='present',
        $confname=$title,
        $content=undef,
        $source=undef,
    ) {

    include '::mirrmaid'

    file { "/etc/mirrmaid/${confname}.conf":
        ensure    => $ensure,
        owner     => 'root',
        group     => 'mirrmaid',
        mode      => '0640',
        seluser   => 'system_u',
        selrole   => 'object_r',
        seltype   => 'etc_t',
        subscribe => Package[$::mirrmaid::packages],
        content   => $content,
        source    => $source,
    }

}
