#
# == Define: mirrmaid::mirror::branch
#
# Manages a branch within a mirrmaid mirror configuration file.
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


define mirrmaid::mirror::branch (
        String[1]                       $mirror,
        String[1]                       $source,
        String[1]                       $target,
        Optional[Array[String[1]]]      $exclude=[],
        Optional[Array[String[1]]]      $include=[],
    ) {

    concat::fragment { "mirrmaid-mirror-${mirror}-branch-${name}":
        target  => "mirrmaid-mirror-${mirror}",
        content => template('mirrmaid/branch.erb'),
        order   => 9,
    }

}
