#
# == Type: Mirrmaid::Defaults
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


type Mirrmaid::Defaults = Hash[
    String[1],
    Struct[
        {
            # Neither is actually optional, but this is required for
            # create_resources to provide defaults missing from Hiera -- the
            # standard use case.
            mirror => Optional[String[1]],
            key    => Optional[Mirrmaid::Key],
            value  => Mirrmaid::Value,
        }
    ],
]
