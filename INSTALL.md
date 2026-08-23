# rstrip - Installation and Use <!-- omit in toc -->


- [Requisites](#requisites)
- [Building](#building)
  - [via CMake](#via-cmake)
  - [via custom makefile (Clang / GCC)](#via-custom-makefile-clang--gcc)


## Requisites

The **rstrip** program (implemented in [**entry.c**](./entry.c)) is implemented in terms of:

* [**CLASP**](https://github.com/synesissoftware/CLASP) - for command-line handling;
* [**cstring**](https://github.com/synesissoftware/cstring) - for resizable C-style strings;
* [**STLSoft**](https://github.com/synesissoftware/STLSoft-1.10) - for CLI utility functions;

Further, the **rstrip_test** program (implemented in [**rstrip_test.cpp**](./rstrip_test.cpp)), which is used only to test the **rstrip** library, also depends on:

* [**Catch2**](https://github.com/catchorg/Catch2) - a sophisticated C++ unit-test library;
* [**xTests**](https://github.com/synesissoftware/xTests) - a simpler C/C++ unit-test library, from which some utility components are used to supplement the tests defined and executed with **Catch2**;

Detailed instructions are provided in the [**REQUISITES.md**](./REQUISITES.md) document for how to obtain and install each of these that you require.

> **NOTE**: if you do not wish to build **rstrip_test**, then you need not obtain/install the **Catch2** and **xTests** dependencies.


## Building


### via CMake

The primary choice for installation is by use of **CMake**.

1. Obtain the latest distribution of **rstrip**, from
   https://github.com/sistools/rstrip/, e.g.

    ```bash
    $ mkdir -p ~/open-source
    $ cd ~/open-source
    $ git clone https://github.com/sistools/rstrip/
    ```

2. Prepare the CMake configuration, via the **prepare_cmake.sh** script, as
   in:

    ```bash
    $ cd ~/open-source/rstrip
    $ ./prepare_cmake.sh
    ```

   **NOTE**: if you intend only to build the **rstrip** program then you can eschew building of tests (via flag `-T`) and use the command:

    ```bash
    $ cd ~/open-source/rstrip
    $ ./prepare_cmake.sh -T
    ```

   In this case, you do not need to have installed [**Catch2**](https://github.com/catchorg/Catch2) or [**xTests**](https://github.com/synesissoftware/xTests); otherwise, you will need to do so (as described in [**REQUISITES.md**](./REQUISITES.md)).

   If **STLSoft** has not been installed, its source-tree root can be supplied with the `--stlsoft-root-dir` (or `-s`) option:

    ```bash
    $ ./prepare_cmake.sh --stlsoft-root-dir ~/open-source/STLSoft
    ```

   The same source-tree root can be supplied through the `STLSOFT` environment variable:

    ```bash
    $ STLSOFT=~/open-source/STLSoft ./prepare_cmake.sh
    ```

3. Run a build of the generated **CMake**-derived build files via the
   **build_cmake.sh** script, as in:

    ```bash
    $ cd ~/open-source/rstrip
    $ ./build_cmake.sh
    ```

   (**NOTE**: if you provide the flag `--run-make` (=== `-m`) in step 3 then you do
   not need this step.)

4. As a check, execute the built program, as in:

    ```bash
    $ cd ~/open-source/rstrip
    $ ./_build/rstrip --help
    ```

   You should see output along the lines of:

    ```plaintext
    Synesis System Tools
    rstrip version 0.1.2.0
    Copyright (c) 2020-2024 Synesis Information Systems
    Strips any trailing whitespace, if present, from input lines

    rstrip [ ... flags/options ... ] [ { <input-file> | - } [ { <output-file> | - } ]]

    Flags:

        standard flags:

        --help
            displays this help and terminates

        --version
            displays version information and terminates
    ```

5. If, in Step 2, you did not skip preparation for building tests (via flag `-T`), you can run the tests as in:

    ```bash
    $ cd ~/open-source/rstrip
    $ ./run_all_unit_tests.sh
    ```

   and you will see output such as:

   ```plaintext
    Executing build of rstrip (via command `make`) and then running all component and unit test programs
    [ 50%] Built target rstrip
    [100%] Built target rstrip_test

    executing /Users/my-user/open-source/rstrip/_build/rstrip_test:
    ===============================================================================
    All tests passed (33 assertions in 1 test case)
   ```

6. Finally, if you wish to do so, you can install the tool on the host, via `cmake`, as in:

    ```bash
    $ cd ~/open-source/rstrip
    $ sudo cmake --install ${SIS_CMAKE_BUILD_DIR:-./_build} --config Release
    ```

   This can be verified as follows:

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


### via custom makefile (Clang / GCC)

Provided in the distribution is a hand-written **makefile**, which handles the four 3rd-party library dependencies via environment variables. For each one, you must either specify an environment variable that holds the value of the root directory of that library's source tree or an environment variable that states that no such is required.

| Library     | Env. var. for root directory    | Env. var. for override    |
| ----------- | ------------------------------- | ------------------------- |
| **CLASP**   | `CLASP_ROOT`                    | `CLASP_USE_INSTALL`       |
| **Catch2**  | `CATCH`                         | `CATCH_USE_INSTALL`       |
| **STLSoft** | `STLSOFT`                       | `STLSOFT_USE_INSTALL`     |
| **xTests**  | `XTESTS_C_ROOT`                 | `XTESTS_USE_INSTALL`      |

For example, if you have already obtained and installed **CLASP**, **Catch2**, and **xTests** (via their respective **CMake** builds), but have a local version of **STLSoft** that you wish to use, then you would issue a command such as:

```bash
$ CLASP_USE_INSTALL=1 CATCH_USE_INSTALL=1 STLSOFT=~/my-STLSoft-root XTESTS_USE_INSTALL=1 make test
```


<!-- ########################### end of file ########################### -->

