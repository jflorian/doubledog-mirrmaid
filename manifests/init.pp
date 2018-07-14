#
# == Class: mirrmaid
#
# Manages the mirrmaid service.
#
# === Parameters
#
# ==== Required
#
# ==== Optional
#
# [*ensure*]
#   Instance is to be 'installed' (default), 'latest' or 'absent'.
#
# === Notes
#
#   You will need to configure mirrmaid with one or more configuration files
#   via the ::mirrmaid::config definition.
#
# === Authors
#
#
#   John Florian <jflorian@doubledog.org>
#
# === Copyright
#
# This file is part of the doubledog-mirrmaid Puppet module.
# Copyright 2010-2018 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later


class mirrmaid (
        $ensure='installed',
    ) inherits ::mirrmaid::params {

    package { $::mirrmaid::params::packages:
        ensure => $ensure,
    }

}
