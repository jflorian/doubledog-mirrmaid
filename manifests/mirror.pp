#
# == Define: mirrmaid::mirror
#
# Manages a mirrmaid mirror configuration file.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# This file is part of the doubledog-mirrmaid Puppet module.
# Copyright 2018 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later


define mirrmaid::mirror (
        Mirrmaid::Branches              $branches,
        Ddolib::File::Ensure            $ensure='present',
        String[1]                       $config_filename=$title,
        String[1]                       $summary_group=$title,
        Optional[Mirrmaid::Defaults]    $defaults={},
        Optional[Array[String[1]]]      $rsync_options=$::mirrmaid::rsync_options,
        Optional[Integer[0]]            $summary_history_count=undef,
        Optional[Integer[600]]          $summary_interval=undef,
        Optional[Array[String[1],1]]    $summary_recipients=undef,
        Optional[Integer[0]]            $summary_size=undef,
    ) {

    include '::mirrmaid'

    concat { "mirrmaid-mirror-${name}":
        ensure    => $ensure,
        path      => "/etc/mirrmaid/${config_filename}.conf",
        owner     => 'root',
        group     => 'mirrmaid',
        mode      => '0640',
        seluser   => 'system_u',
        selrole   => 'object_r',
        seltype   => 'etc_t',
        subscribe => Package[$::mirrmaid::packages],
        order     => 'numeric',
    }

    concat::fragment { "mirrmaid-mirror-${name}":
        target  => "mirrmaid-mirror-${name}",
        content => template('mirrmaid/mirror.erb'),
        order   => 0,
    }

    ::mirrmaid::mirror::default { "rsync_options for mirror ${name}":
        mirror => $name,
        key    => 'rsync_options',
        value  => $rsync_options,
    }

    create_resources(
            ::mirrmaid::mirror::default,
            $defaults,
            {'mirror' => $name}
    )

    create_resources(
            ::mirrmaid::mirror::branch,
            $branches,
            {'mirror' => $name}
    )

}
