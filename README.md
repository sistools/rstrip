# rstrip <!-- omit in toc -->

Strips trailing whitespace from all input lines


![C](https://img.shields.io/badge/C-00599C?style=flat&logo=c&logoColor=white)
[![License](https://img.shields.io/badge/License-BSD_3--Clause-blue.svg)](https://opensource.org/licenses/BSD-3-Clause)
[![GitHub release](https://img.shields.io/github/v/release/sistools/rstrip.svg)](https://github.com/sistools/rstrip/releases/latest)
[![Last Commit](https://img.shields.io/github/last-commit/sistools/rstrip)](https://github.com/sistools/rstrip/commits/master)
[![CI](https://github.com/sistools/rstrip/actions/workflows/ci.yml/badge.svg)](https://github.com/sistools/rstrip/actions/workflows/ci.yml)


## Table of Contents <!-- omit in toc -->

- [Introduction](#introduction)
- [Installation](#installation)
- [Components](#components)
- [Examples](#examples)
- [Project Information](#project-information)
  - [Where to get help](#where-to-get-help)
  - [Contribution guidelines](#contribution-guidelines)
  - [Dependencies](#dependencies)
    - [Tests-only Dependencies](#tests-only-dependencies)
  - [Related projects](#related-projects)
  - [License](#license)


## Introduction

**rstrip** is a small, standalone utility program that removes trailing whitespace from lines in its input.


## Installation

Detailed instructions - via **CMake**, via bundling, via custom makefile
parameters - are provided in the accompanying [INSTALL.md](./INSTALL.md)
file.


## Components

The project creates a single executable program, **rstrip**.


## Examples

```bash
$ cd ~
$ echo -e "abc\n  def\nghi  \njkl\t" | sed -e 's/$/*/'
abc*
  def*
ghi  *
jkl     *
$ echo -e "abc\n  def\nghi  \njkl\t" | rstrip | sed -e 's/$/*/'
abc*
  def*
ghi*
jkl*
```


## Project Information


### Where to get help

[GitHub Page](https://github.com/sistools/rstrip "GitHub Page")


### Contribution guidelines

Defect reports, feature requests, and pull requests are welcome on [the **cstring** GitHub page](https://github.com/sistools/rstrip).


### Dependencies

**rstrip** depends on:

* [**CLASP**](https://github.com/synesissoftware/CLASP);
* [**STLSoft 1.10**](https://github.com/synesissoftware/STLSoft-1.10);
* [**cstring**](https://github.com/synesissoftware/cstring);


#### Tests-only Dependencies

For unit-testing, **rstrip** depends additionally on:

* [**xTests**](https://github.com/synesissoftware/xTests/);


### Related projects

Other (similar) project include:

* [**chomp**](https://github.com/sistools/chomp)
* [**lstrip**](https://github.com/sistools/lstrip)


### License

**rstrip** is released under the 3-clause BSD license. See [LICENSE](./LICENSE) for details.


<!-- ########################### end of file ########################### -->

