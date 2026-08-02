# rstrip - Requisites <!-- omit in toc -->


- [Introduction](#introduction)
- [Installation by CMake](#installation-by-cmake)
  - [CLASP](#clasp)
  - [cstring](#cstring)
  - [Catch2 - required only for testing rstrip](#catch2---required-only-for-testing-rstrip)
  - [STLSoft](#stlsoft)
  - [xTests - required only for testing rstrip](#xtests---required-only-for-testing-rstrip)
- [Installation by other means](#installation-by-other-means)


## Introduction

The **rstrip** program (implemented in [**entry.c**](./entry.c)) is implemented in terms of:

* [**CLASP**](https://github.com/synesissoftware/CLASP) - for command-line handling;
* [**STLSoft**](https://github.com/synesissoftware/STLSoft-1.10) - for CLI utility functions;

Further, the **rstrip_test** program (implemented in [**rstrip_test.cpp**](./rstrip_test.cpp)), which is used only to test the **rstrip** library, also depends on:

* [**Catch2**](https://github.com/catchorg/Catch2) - a sophisticated C++ unit-test library;
* [**xTests**](https://github.com/synesissoftware/xTests) - a simpler C/C++ unit-test library, from which some utility components are used to supplement the tests defined and executed with **Catch2**;

> **NOTE**: if you do not wish to build **rstrip_test**, then you need not obtain/install the **Catch2** and **xTests** dependencies.


## Installation by CMake


### CLASP

The **CLASP** library provides command-line argument parsing, including parsing of arguments into _flags_, _options_, and _variables_, as well as a number of utility facilities (such as functions for providing pro-forma output for `--help` and `--version` flags).

**CLASP** is obtained from **https://github.com/synesissoftware/CLASP**, and it provides the means to install via **CMake**, as in the following:

```bash
$ mkdir -p ~/open-source
$ cd ~/open-source
$ git clone https://github.com/synesissoftware/CLASP
$ cd ~/open-source/CLASP
$ ./prepare_cmake.sh -m
$ sudo cmake --install ./_build --config Release
```


### cstring

The **cstring** library provides resizeable C-style strings, and vectors of them.

**cstring** is obtained from **https://github.com/synesissoftware/cstring**, and it provides the means to install via **CMake**, as in the following:

```bash
$ mkdir -p ~/open-source
$ cd ~/open-source
$ git clone https://github.com/synesissoftware/cstring
$ cd ~/open-source/cstring
$ ./prepare_cmake.sh -m
$ sudo cmake --install ./_build --config Release
```


### Catch2 - required only for testing rstrip

**Catch2** is "_A modern, C++-native, test framework for unit-tests, TDD and BDD - using C++14, C++17 and later (C++11 support is in v2.x branch, and C++03 on the Catch1.x branch)_"

We have used version **2.x** of **Catch2** in the building of **rstrip**, and the following instructions are tailored to that branch specifically.

```bash
$ mkdir -p ~/open-source
$ cd ~/open-source
$ git clone -o catchorg https://github.com/catchorg/Catch2
$ cd ~/open-source/Catch2
$ git checkout --track catchorg/v2.x
$ sudo cmake --build _build/ --target install
```


### STLSoft

The **STLSoft** libraries provide a wide range of compiler/library discrimination and compatibility facilities, operating system API façades, and a number of extended components over and above what is provided in the standard library.

**STLSoft** is obtained from **https://github.com/synesissoftware/STLSoft-1.10**, and it provides the means to install via **CMake**, as in the following:

```bash
$ mkdir -p ~/open-source
$ cd ~/open-source
$ git clone https://github.com/synesissoftware/STLSoft-1.10
$ cd ~/open-source/STLSoft-1.10
$ ./prepare_cmake.sh -m
$ sudo cmake --install ./_build --config Release
```


### xTests - required only for testing rstrip

**xTests** is a simple, easy-to-use, efficient testing library, for C, C++. It's not particularly great, but it's small and portable enough to be bundled with other, more important, libraries.

**xTests** is obtained from **https://github.com/synesissoftware/xTests**, and it provides the means to install via **CMake**, as in the following:

```bash
$ mkdir -p ~/open-source
$ cd ~/open-source
$ git clone https://github.com/synesissoftware/xTests
$ cd ~/open-source/xTests
$ ./prepare_cmake.sh -m
$ sudo cmake --install ./_build --config Release
```


## Installation by other means

If you cannot or will not use **CMake** and wish to use other means, we do not currently provide instructions for that - because we cannot know what or how you wish to operate - but if you post a question (in **https://github.com/sistools/rstrip/issues**) we will attempt to help you.


<!-- ########################### end of file ########################### -->

