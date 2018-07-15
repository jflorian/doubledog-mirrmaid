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
* [mirrmaid::mirror](#mirrmaidmirror-defined-type)
* [mirrmaid::mirror::branch](#mirrmaidmirrorbranch-defined-type)


### Classes

#### mirrmaid class

This class manages the mirrmaid package and sets overall module defaults.  It must be included once.

##### `ensure`
The state required of the package.  The default is `'installed'`.

##### `packages`
An array of package names needed for the mirrmaid installation.  The default should be correct for supported platforms.

##### `rsync_options`
An array of general options to be passed to rsync.  Note that **ORDER CAN BE IMPORTANT**, as some options may override some or all of others.  This sets the default that will be used for each [mirrmaid::mirror](#mirrmaidmirror-defined-type) and his module itself provides a default suitable for most use cases.


### Defined types

#### mirrmaid::config defined type

This defined type manages a mirrmaid configuration file.

##### `namevar` (REQUIRED)
An arbitrary identifier for the file instance unless the *confname* parameter is not set in which case this must provide the value normally set with the *confname* parameter.

##### `confname`
Name to be given to the configuration file, without path details nor suffix.  This may be used in place of *namevar* if it's beneficial to give namevar an arbitrary value.

##### `content`, `source`
Literal string or Puppet source URI for the configuration file content.  One and only one of *content* or *source* must be given.

##### `ensure`
Instance is to be `present` (default) or `absent`.  Alternatively, a Boolean value may also be used with `true` equivalent to `present` and `false` equivalent to `absent`.


#### mirrmaid::mirror defined type

This defined type manages a mirrmaid mirror configuration file.

##### `namevar` (REQUIRED)
An arbitrary and unique identifier for the mirror instance.

##### `confname`
Name to be given to the configuration file, without path details nor suffix.  The default (recommended) is the value of *namevar*.

##### `ensure`
Instance is to be `present` (default) or `absent`.  Alternatively, a Boolean value may also be used with `true` equivalent to `present` and `false` equivalent to `absent`.

##### `rsync_options`
An array of general options to be passed to rsync.  Note that **ORDER CAN BE IMPORTANT**, as some options may override some or all of others.

##### `summary_history_count`
Keep this many historical copies of operational summaries on disk before they are rotated out of existence.  A minimum value of one is silently enforced.  The default is that from the package.

##### `summary_interval`
The minimum number of seconds that mirrmaid will wait after sending an operations summary via email before sending another.  A minimum value of ten minutes is silently enforced.  The default is that from the package.

##### `summary_recipients`
An array of email addresses to whom the operations summaries should be sent.  The default is that from the package.

##### `summary_size`
If the size (in bytes) of the operations summary has exceeded this size threshold, the email will be sent early without necessarily waiting for the *summary_interval* to have elapsed.  This can be useful to alert the *summary_recipients* of major trouble in a more expedient way.  Set this to zero to defeat this feature.  The default is that from the package.


#### mirrmaid::mirror::branch defined type

This defined type manages a branch within a mirrmaid mirror configuration file.

##### `namevar` (REQUIRED)
An arbitrary and unique identifier for the branch within the mirror instance.

##### `mirror` (REQUIRED)
The unique identifier for the mirror instance to which this branch is associated.

##### `source` (REQUIRED)
A string providing the rsync URI to be mirrored.

##### `target` (REQUIRED)
A string providing the local file system path to where the mirror is to be rooted.

##### `exclude`
An array of strings to be passed to rsync as exclusions.  The default is an empty array, i.e., nothing will be excluded.  See the section `FILTER RULES` in the rsync man page for more details.

##### `include`
An array of strings to be passed to rsync as inclusions.  Because mirrmaid passes the *exclude* items to rsync first, followed by the *include* items, these are effectively a means for overriding general *exclude* items.  For example, you might set `exclude = ['*.iso']` and `include = ['*KDE*.iso']` to filter out all but the KDE images.  The default is an empty array.  See the section `FILTER RULES` in the rsync man page for more details.


## Limitations

Tested on modern Fedora and CentOS releases, but likely to work on any Red Hat variant.  Adaptations for other operating systems should be trivial as this module follows the data-in-module paradigm.  See `data/common.yaml` for the most likely obstructions.  If "one size can't fit all", the value should be moved from `data/common.yaml` to `data/os/%{facts.os.name}.yaml` instead.  See `hiera.yaml` for how this is handled.

## Development

Contributions are welcome via pull requests.  All code should generally be compliant with puppet-lint.
