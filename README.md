<!--
# This file is part of the doubledog-mirrmaid Puppet module.
# Copyright 2018 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later
-->

# mirrmaid

#### Table of Contents

1. [Description](#description)
1. [Setup - The basics of getting started with mirrmaid](#setup)
    * [What mirrmaid affects](#what-mirrmaid-affects)
    * [Setup requirements](#setup-requirements)
    * [Beginning with mirrmaid](#beginning-with-mirrmaid)
1. [Usage - Configuration options and additional functionality](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Classes](#classes)
    * [Defined types](#defined-types)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module lets you manage mirrmaid, the mirror manager.

## Setup

### What mirrmaid Affects

### Setup Requirements

### Beginning with mirrmaid

## Usage

## Reference

**Classes:**

* [mirrmaid](#mirrmaid-class)

**Defined types:**

* [mirrmaid::config](#mirrmaidconfig-defined-type)


### Classes

#### mirrmaid class

This class manages the mirrmaid package.  It is generally unnecessary to include this directly as it is included as needed by other resources in this module.

##### `ensure`
The state required of the package.  The default is `'installed'`.

##### `packages`
An array of package names needed for the mirrmaid installation.  The default should be correct for supported platforms.


### Defined types

#### mirrmaid::config defined type

This defined type manages a mirrmaid configuration file.

##### `namevar` (REQUIRED)
An arbitrary identifier for the file instance unless the *confname* parameter is not set in which case this must provide the value normally set with the *confname* parameter.

##### `confname`
Name to be given to the configuration file, without path details nor suffix.  This may be used in place of *namevar* if it's beneficial to give namevar an arbitrary value.

##### `content`, `source`
Literal string or Puppet source URI for the configuration file content.  One and only one of *content* or *source* must be given.

##### `cronjob`
Puppet source URI of the cron job file to be installed.  Use the default (undef) if you do not want a cron job file installed.  See the `cron::jobfile` defined type for more details regarding format, requirements, etc.

##### `ensure`
Instance is to be `present` (default) or `absent`.  Alternatively, a Boolean value may also be used with `true` equivalent to `present` and `false` equivalent to `absent`.


## Limitations

Tested on modern Fedora and CentOS releases, but likely to work on any Red Hat variant.  Adaptations for other operating systems should be trivial as this module follows the data-in-module paradigm.  See `data/common.yaml` for the most likely obstructions.  If "one size can't fit all", the value should be moved from `data/common.yaml` to `data/os/%{facts.os.name}.yaml` instead.  See `hiera.yaml` for how this is handled.

## Development

Contributions are welcome via pull requests.  All code should generally be compliant with puppet-lint.
