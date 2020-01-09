#
# == Define: mirrmaid::mirror::default
#
# Manages a default within a mirrmaid mirror configuration file.
#
# === Authors
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# This file is part of the doubledog-mirrmaid Puppet module.
# Copyright 2018-2020 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later


define mirrmaid::mirror::default (
        Mirrmaid::Value $value,
        Mirrmaid::Key   $mirror,
        Mirrmaid::Key   $key=$title,
    ) {

    concat::fragment { "mirrmaid-mirror-${mirror}-default-${name}":
        target  => "mirrmaid-mirror-${mirror}",
        content => template('mirrmaid/default.erb'),
        order   => 3,
    }

}
