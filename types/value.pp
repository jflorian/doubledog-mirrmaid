#
# == Type: Mirrmaid::Value
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


type Mirrmaid::Value = Variant[
    String[1],
    Array[String[1]],
]
