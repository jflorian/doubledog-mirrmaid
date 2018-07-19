#
# == Type: mirrmaid::default
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


type Mirrmaid::Default = Variant[
    String,
    Array[String],
]
