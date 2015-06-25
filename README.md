# Puppet Concurrency Kit Module

This Puppet module installs the [Concurrency Kit](http://concurrencykit.org/) which provides concurrency primitives, safe memory reclamation mechanisms and non-blocking data structures for the research, design and implementation of high performance concurrent systems. This module can install from packages, or build and install from a git repository or a source tar archive.

# Classes

## Base Class

### `ck`

This is the primary class for installing and managing the concurrency kit libraries.

#### Minimal usage

```puppet
include ck
```

#### Recommended usage

```puppet
include gcc

class {'ck':
  provider => 'git',
  build    => true,
}
```

#### Parameters

##### `ensure`
This parameter is passed through to the package resources when using the `package` provider. It currently has no effect on the other providers. The default value is `present`
##### `provider`
This parameter determines which provider is used to install the concurrency kit. The current providers are `package` which installs from packages, `git` which downloads the source code from a git repository, and `tar` which downloads the source code as a `.tar.gz` archive from a URL. The default value is `package`
##### `version`
This is the version of the concurrency kit to be installed from source, package versions are handled via the `ensure` parameter. The default value is `0.4.5`
##### `dev_libs`
If set to true, this will install the concurrency kit development libraries. The default value is `false`
##### `packages`
The name of the packages to be installed as an array of strings. The default value is operating system dependent. Some operating systems have no defined default package which will throw an error if this parameter is not defined.
##### `dev_packages`
The name of the development packages to be installed as an array of strings. The default value is operating system dependent. Some operating systems have no defined default development package which will throw an error if this parameter is not defined.
##### `manage_repos`
If set to true, the `ck` class will set up a repository to install the concurrency kit packages from. Use of this parameter is not recommended, see the notes on the `ck::repository` class. The default value is `false`
##### `src_dir`
This sets the directory where the source code downloaded by the `git` or `tar` provider will be linked to. The default value is `/usr/src/ck`
##### `repo_url`
This sets the URL to the PPA with the concurrency kit packages. The default is undefined, which will use an OS specific URL. Use of this parameter is not recommended, see the notes on the `ck::repository` class.
##### `src_url`
This sets the URL of the tar archive used to install the concurrency kit source with the `tar` provider. The default value will download the appropriate archive from the concurrency kit site based on the value of the `version` parameter.
##### `git_url`
This sets the URL for the git repository used to install the concurrency kit source with the `git` provider. The default value will download the appropriate source from the [concurrency kit GitHub repository](https://github.com/concurrencykit/ck). The `version` parameter is used as a reference to a specific commit, branch, or tag in the git repository.
##### `build`
If set to `true` the source code downloaded by the `git` or `tar` provider will be built and installed. Requires the `gcc` class from the [puppetlabs-gcc module](https://forge.puppetlabs.com/puppetlabs/gcc) to have been previously declared. The default value is `false`
##### `regressions`
If set to `true` the concurrency kit regressions will be compiled before installation when the `build` parameter is `true`. The default value is `false`

## Private Classes

Though these classes could be used in a manifest, it is recommended that they are configured via the base `ck` class.

### `ck::repository`

Though this module provides a class that manages the package repository that provides the `ck` packages, they are not well tested and are primarily intended to provide an example of how package repositories should be defined. It is recommended that package repositories are defined prior calling the ck module instead. Currently the `ck::repository` class only works for Ubuntu 14.10 as this is the only operating system for which packages are known to be distributed.

#### Parameters

##### `repo_url`
The URL of the PPA holding the concurrency kit packages.

### `ck::source::build`

This class requires `gcc` class from the [puppetlabs-gcc module](https://forge.puppetlabs.com/puppetlabs/gcc) to have been previously declared.

#### Parameters

##### `src_dir`
The directory where the concurrency kit source is to be built from. The default is `/usr/src/ck`
##### `regressions`
If set to `true` the concurrency kit regressions will be compiled before installation when the `build` parameter is `true`. The default value is `false`

### `ck::source::git`

Downloads the concurrency kit source from a git repository.

#### Parameters

##### `git_url`
This sets the URL for the git repository used to install the concurrency kit source with the `git` provider. The default value will download the appropriate source from the [concurrency kit GitHub repository](https://github.com/concurrencykit/ck).
##### `version`
The `version` parameter is used as a reference to a specific commit, branch, or tag in the git repository. The default value is `0.4.5`
##### `src_dir`
This sets the directory where the source code checked out  will be linked to.

### `ck::source::install`

Installs the concurrency kit previously built in the source directory.

#### Parameters

##### `src_dir`
The directory where the previously built concurrency kit source is to be installed from. The default is `/usr/src/ck`

### `ck::source::tar`

Downloads and uncompress the concurrency kit source code from a `tar.gz` archive.

#### Parameters

##### `src_url`
Sets the URL from where the concurrency kit source is downloaded from. The default value is undefined, which will use the `version` parameter to create a default URL to download the source from the concurrency kit web site.
##### `version`
The `version` parameter is used as a download a specific version from the concurrency kit web site if there is no `src_url` defined. The default value is `0.4.5`
##### `src_dir`
This sets the directory where the source code decompressed from the tar archive will be linked to.

# Attribution

This module is derived from the puppet-blank module by Aaron Hicks (aethylred@gmail.com)
``
* https://github.com/Aethylred/puppet-blank

This module has been developed for the use with Open Source Puppet (Apache 2.0 license) for automating server & service deployment.

* http://puppetlabs.com/puppet/puppet-open-source/

# Licensing

This file is part of the ck Puppet module.

Licensed under the [Apache License, Version 2.0](http://www.apache.org/licenses/LICENSE-2.0)
