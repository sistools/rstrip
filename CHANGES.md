# rstrip - Changes <!-- omit in toc -->


## 0.2.0 - 1st September 2026

* Fixed closing of **stdin** / **stdout** when input or output is a pipe;
* Output-write failures are now reported and reflected in the exit code;
* Replaced the deprecated **CLASP** alias terminology with `clasp_specification_t` and **`CLASP_SPECIFICATION_ARRAY_TERMINATOR`**;
* Consume **sistools-common-c** for `--help` / `--version` via **`stcc_show_help()`** / **`stcc_show_version()`**;
* Version output now uses **Diagnosticism** version strings (via **sistools-common-c**);
* Added **`SISTOOL_RSTRIP_VER_ALPHABETA`**;


## 0.1.3 - 27th August 2026

* Fixed **cmake/BuildType.cmake** so the default `CMAKE_BUILD_TYPE` is set correctly in the CMake cache (`set(CMAKE_BUILD_TYPE … CACHE …)` instead of `set(CACHE CMAKE_BUILD_TYPE …)`);


## 0.1.2 - 24th August 2026

* Added **Doxyfile**, **generate_doxygen.sh**, **doc/mainpage.md**, and **doc/rstrip.1**;
* Added installation verification for the section-1 man page to **ci-cell.yml**;
* Fixed **CMakeLists.txt** support for uninstalled **STLSoft** source trees supplied via **STLSOFT** or **--stlsoft-root-dir**;
* Expanded **ci.yml** push-branch coverage;
* Modernised **.gitattributes**, **.gitignore**, **.vimrc**, and **.vscode/settings.json**;
* Updated **CMakeLists.txt** for C17/C++17 defaults, MSVC support, man-page installation, and build diagnostics;
* Updated CMake helper scripts with project identification, diagnostics, and shared CMake build-directory support;
* Updated **README.md**, **INSTALL.md**, **REQUISITES.md**, and **TODO.md**;


## 0.1.1 - 16th August 2026

* Added modular GitHub Actions CI (**ci.yml** / **ci-cell.yml**) with Linux/macOS/Windows matrix (incl. **cstring** dependency install), tests, and install verification;
* Modernised **CMakeLists.txt** (**CLASP** 0.15 / **cstring** / **STLSoft** 1.11 / **Catch2** / **xTests**; **CLASP::core** / **cstring::core** linkage; MSVC options; `BUILD_TESTING`);
* Fixed **rstrip.c** `CSTRING_RC` initialisation and write-result handling;
* Added **cmake/BuildType.cmake**;
* Canonicalised CMake helper scripts (**prepare_cmake.sh**, **build_cmake.sh**, **clean_cmake.sh**, **remove_cmake_artefacts.sh**, **run_all_unit_tests.sh**) with **SIS_CMAKE_*** support and MinGW/MSVC flags;
* Added **run_all_unit_tests.cmd**;
* Added **.sis/script_info_lines.txt** and **.sis/project_name.txt**;
* Project boilerplate updates (**.gitattributes**, **.gitignore**, **.vimrc**, **.vscode/settings.json**);
* Added **NEWS.md** and modernised **README.md** (badges, TOC);
* Updated **LICENSE** copyright years to 2020-2026;


## 0.1.0 - 4th February 2024

* Initial CMake-based release (**CMakeLists.txt**, helper scripts, unit tests, and project documentation);


<!-- ########################### end of file ########################### -->
