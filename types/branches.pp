#
# == Type: Mirrmaid::Branches
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


type Mirrmaid::Branches = Hash[
    String[1],
    Struct[
        {
            mirror  => Optional[String[1]],
            source  => String[1],
            target  => String[1],
            exclude => Optional[Mirrmaid::Value],
            include => Optional[Mirrmaid::Value],
        }
    ],
]
