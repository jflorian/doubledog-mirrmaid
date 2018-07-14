#
# == Class: mirrmaid::params
#
# Parameters for the mirrmaid puppet module.
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


class mirrmaid::params {

    case $::operatingsystem {

        'CentOS', 'Fedora': {

            $packages = 'mirrmaid'

        }

        default: {
            fail ("${title}: operating system '${::operatingsystem}' is not supported")
        }

    }

}
