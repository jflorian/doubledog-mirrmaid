#
# == Type: Mirrmaid::Key
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


# Keys must be valid for both YAML and Python's ConfigParser (for both
# sections and items).
type Mirrmaid::Key = Pattern[/\A[[:alnum:]_ ][[:alnum:]_ ]*\Z/]
