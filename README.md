<!--
# This file is part of the doubledog-mirrmaid Puppet module.
# Copyright 2018 John Florian
# SPDX-License-Identifier: GPL-3.0-or-later
-->

# mirrmaid

#### Table of Contents

1. [Description](#description)
1. [Usage - a quick start guide](#usage)
1. [Reference - An under-the-hood peek at what the module is doing and how](#reference)
    * [Classes](#classes)
    * [Defined types](#defined-types)
    * [Data types](#data-types)
1. [Limitations - OS compatibility, etc.](#limitations)
1. [Development - Guide for contributing to the module](#development)

## Description

This module lets you manage mirrmaid, the mirror manager.

## Usage

This module is designed to be driven primarily from Hiera, though that's not necessary it is the easiest way.  Thus, from the Puppet side of things, you need only:

```puppet
include '::mirrmaid'
```

In addition, you'll also need one or more cron jobs (or similar) to actually execute mirrmaid per your requirements.  Everything else is best left to declarations in your Hiera data.  While there are many ways to do so, illustrated below is an approach that's both flexible and concise.  First, we start by defining a trivial structure of mirror sources so that we may easily change sources later should the need arise:

```yaml
sources:
    kernel_org:
        host:               rsync://mirrors.kernel.org
        centos_prefix:      centos
        epel_prefix:        fedora-epel
        fedora_prefix:      fedora
    princeton_edu:
        host:               rsync://mirror.math.princeton.edu
        centos_prefix:      pub/centos
        epel_prefix:        pub/epel
        fedora_prefix:      pub/fedora/linux
    syringanetworks_net:
        host:               rsync://mirrors.syringanetworks.net
        centos_prefix:      centos
        epel_prefix:        fedora-epel
        fedora_prefix:      fedora/linux
```

The prefix entries are tied to each source so that anything deeper in their mirror trees has a consistent layout.  In essence, this is where they've chosen to warehouse their various mirrors.  This approach obviously requires that each source provide all the content you want.  You would likely be unhappy if, in changing to another source, large parts of your mirror trees are wiped out.

With the sources defined, we can get on with the actual mirrmaid configuration.  A complete example is included and discussed in more detail afterwards.

```yaml
mirrmaid::mirrors:
    centos:
        branches:
            all of centos:
                source:     "%{hiera('sources.kernel_org.host')}/%{hiera('sources.kernel_org.centos_prefix')}"
                target:     /pub/mirrors/centos
                exclude:
                    - '*.torrent'
                    - '*sum.txt'
                    - '.*'
                    - 'dir_sizes'
                    - 'filelist.gz'
                include:
                    - '.treeinfo'
                    - '.treeinfo.signed'
    epel:
        branches:
            all of epel except testing:
                source:     "%{hiera('sources.kernel_org.host')}/%{hiera('sources.kernel_org.epel_prefix')}"
                target:     /pub/mirrors/epel
                exclude:
                    - 'fullfilelist'
                    - 'fullfiletimelist-epel'
                    - 'testing/'
    fedora:
        branches:
            release 28:
                source:     '%(fedora_source)s/releases/28'
                target:     '%(fedora_target)s/releases/28'
                exclude:    '%(fedora_excludes)s'
                include:    '%(fedora_includes)s'
            updates for 28:
                source:     '%(fedora_source)s/updates/28'
                target:     '%(fedora_target)s/updates/28'
                exclude:    '%(fedora_excludes)s'
                include:    '%(fedora_includes)s'
            release 27:
                source:     '%(fedora_source)s/releases/27'
                target:     '%(fedora_target)s/releases/27'
                exclude:    '%(fedora_excludes)s'
                include:    '%(fedora_includes)s'
            updates for 27:
                source:     '%(fedora_source)s/updates/27'
                target:     '%(fedora_target)s/updates/27'
                exclude:    '%(fedora_excludes)s'
                include:    '%(fedora_includes)s'
        defaults:
            fedora_excludes:
                value:
                    - '.*'
                    - 'SRPMS/'
                    - 'debug/'
                    - 'drpms/'
                    - 'jigdo/'
                    - 'source/'
            fedora_includes:
                value:
                    - '.treeinfo'
                    - '.treeinfo.signed'
            fedora_source:
                value: "%{hiera('sources.kernel_org.host')}/%{hiera('sources.kernel_org.fedora_prefix')}"
            fedora_target:
                value: /pub/mirrors/fedora
```

From this example, it can be seen that three mirrors have been defined, one each for CentOS, (Fedora) EPEL and Fedora.  Each mirror is composed of one or more branches detailing what exactly is to be mirrored, from where it comes and to where it goes.  The name of the mirror becomes the name of one mirrmaid configuration file.  The name of each branch becomes one mirror facet defined within that file.  By default, both mirrmaid itself and this module include all content and exclude nothing.  Specific exclusions may be used to reduce what is mirrored, e.g., hidden files while specific inclusions may be used to override those exclusions, e.g., a few select hidden files.

This example contains two different types of interpolation references.  First, there are the Hiera lookups of which you should be familiar.  Second, are the Python-style permitted by mirrmaid which utilizes [Python's ConfigParser module](https://docs.python.org/3/library/configparser.html#interpolation-of-values).  Why both and not just Hiera alone?  This is explained in the [mirrmaid::mirror::default](#mirrmaidmirrordefault-defined-type) defined type documentation, but in short, it makes the resulting configuration file more compact.  It's also slightly less cumbersome than Hiera's own lookup syntax.


## Reference

**Classes:**

* [mirrmaid](#mirrmaid-class)

**Defined types:**

* [mirrmaid::mirror](#mirrmaidmirror-defined-type)
* [mirrmaid::mirror::branch](#mirrmaidmirrorbranch-defined-type)
* [mirrmaid::mirror::default](#mirrmaidmirrordefault-defined-type)

**Data types:**

* [Mirrmaid::Branches](#mirrmaidbranches-data-type)
* [Mirrmaid::Defaults](#mirrmaiddefaults-data-type)
* [Mirrmaid::Key](#mirrmaidkey-data-type)
* [Mirrmaid::Value](#mirrmaidvalue-data-type)


### Classes

#### mirrmaid class

This class manages the mirrmaid package and sets overall module defaults.  It must be included once.

##### `mirrors` (REQUIRED)
A hash whose keys are mirror names and whose values are hashes comprising the
same parameters you would otherwise pass to [mirrmaid::mirror](#mirrmaidmirror-defined-type).

##### `ensure`
The state required of the package.  The default is `'installed'`.

##### `packages`
An array of package names needed for the mirrmaid installation.  The default should be correct for supported platforms.

##### `rsync_options`
An array of general options to be passed to rsync.  Note that **ORDER CAN BE IMPORTANT**, as some options may override some or all of others.  This sets the default that will be used for each [mirrmaid::mirror](#mirrmaidmirror-defined-type) and his module itself provides a default suitable for most use cases.


### Defined types


#### mirrmaid::mirror defined type

This defined type manages a mirrmaid mirror configuration file.  You generally needn't reference this defined type directly but rather indirectly via  the *mirrors* parameter on the [mirrmaid](#mirrmaid-class) class.

##### `namevar` (REQUIRED)
An arbitrary and unique identifier for the mirror instance.

##### `branches` (REQUIRED)
A hash whose keys are branch names and whose values are hashes comprising the same parameters you would otherwise pass to [mirrmaid::mirror::branch](#mirrmaidmirrorbranch-defined-type).  It's unnecessary for the hash to specify the *mirror* parameter since this defined type passes that along by default.

##### `confname`
Name to be given to the configuration file, without path details nor suffix.  The default (recommended) is the value of *namevar*.

##### `defaults`
A hash whose keys are default names and whose values are hashes comprising the same parameters you would otherwise pass to [mirrmaid::mirror::default](#mirrmaidmirrordefault-defined-type).  It's unnecessary for the hash to specify the *mirror* parameter since this defined type passes that along by default.

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

This defined type manages a branch within a mirrmaid mirror configuration file.  You generally needn't reference this defined type directly but rather indirectly via [mirrmaid::mirror](#mirrmaidmirror-defined-type).

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


#### mirrmaid::mirror::default defined type

This defined type manages a default within a mirrmaid mirror configuration file.  Such entries appear within the special `[DEFAULT]` section.  These values can then be referenced from any other configuration item via the special `%(name)s` syntax.   The primary value of doing so is to avoid repetition in the configuration file.

For example, you may have a standard set of exclusions you wish to impose on every branch in a mirror.  While you could avoid the repetition in your Puppet manifest or Hiera data through references to a common shared value, the resultant mirrmaid configuration file would still have this repetition.  That's not necessarily bad, but this approach avoids repetition from start to finish and can make reviewing the configuration files easier.  You might even find the Puppet/Hiera resources easier to visualize in this way, too.

You generally needn't reference this defined type directly but rather indirectly via [mirrmaid::mirror](#mirrmaidmirror-defined-type) via the *defaults* parameter.

##### `namevar` (REQUIRED)
An arbitrary and unique identifier for the default within the mirror instance.  See the *key* parameter for more details.

##### `mirror` (REQUIRED)
The unique identifier for the mirror instance to which this default is associated.

##### `value` (REQUIRED)
The [Mirrmaid::Value](#mirrmaidvalue-data-type) that the default is to take.

##### `key`
The [Mirrmaid::Key](#mirrmaidkey-data-type) that uniquely identifies the default.  If unset, this will take the value of the *namevar* parameter.  This makes it possible to have the same *key* in multiple mirror configuration files by giving each an distinct *namevar* to satisfy Puppet's requirement for uniquely named resources.


### Data types

#### Mirrmaid::Branches data type

This data type represents a hash whose keys are branch names and whose values are hashes comprising the same parameters you would otherwise pass to [mirrmaid::mirror::branch](#mirrmaidmirrorbranch-defined-type).


#### Mirrmaid::Defaults data type

This data type represents a hash whose keys are default names and whose values are hashes comprising the same parameters you would otherwise pass to [mirrmaid::mirror::default](#mirrmaidmirrordefault-defined-type).


#### Mirrmaid::Key data type

In the most basic sense, a mirrmaid configuration file is composed of key/value pairs.  This data type represents the key half of any such pair.  Acceptable values are strings consisting of one or more characters and may consist of: alpha characters, numeric digits, underscores and spaces.


#### Mirrmaid::Value data type

In the most basic sense, a mirrmaid configuration file is composed of key/value pairs.  This data type represents the value half of any such pair.  Acceptable values are non-empty strings or non-empty arrays of such strings.


## Limitations

Tested on modern Fedora and CentOS releases, but likely to work on any Red Hat variant.  Adaptations for other operating systems should be trivial as this module follows the data-in-module paradigm.  See `data/common.yaml` for the most likely obstructions.  If "one size can't fit all", the value should be moved from `data/common.yaml` to `data/os/%{facts.os.name}.yaml` instead.  See `hiera.yaml` for how this is handled.

## Development

Contributions are welcome via pull requests.  All code should generally be compliant with puppet-lint.
