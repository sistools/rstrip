# rstrip <!-- omit in toc -->

Strips trailing whitespace from all input lines


## Table of Contents

1. [Introduction](#introduction)
2. [Installation](#installation)
3. [Components](#components)
4. [Examples](#examples)
5. [Project Information](#project-information)

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

