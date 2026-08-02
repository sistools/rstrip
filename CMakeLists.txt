
# ######################################################################## #
# File:     /CMakeLists.txt
#
# Purpose:  Top-level CMake lists file for rstrip
#
# Created:  2nd April 2020
# Updated:  4th February 2024
#
# ######################################################################## #


# ##########################################################
# CMake

cmake_minimum_required(VERSION 3.20 FATAL_ERROR)

# require out-of-source builds
file(TO_CMAKE_PATH "${CMAKE_CURRENT_BINARY_DIR}/CMakeLists.txt" LOC_PATH)
if(EXISTS "${LOC_PATH}")

	message(FATAL_ERROR "You cannot build in a source directory (or any directory with a CMakeLists.txt file). Please make a build subdirectory. Feel free to remove CMakeCache.txt and CMakeFiles.")
endif()

# directory for CMake specific extensions and source files.
set(CMAKE_MODULE_PATH "${CMAKE_CURRENT_SOURCE_DIR}/cmake" ${CMAKE_MODULE_PATH})


# ##########################################################
# project

project(rstrip
	DESCRIPTION "rstrip is a small, standalone utility program that removes trailing whitespace from lines in its input"
	HOMEPAGE_URL "https://github.com/sistools/rstrip"
	LANGUAGES C CXX
)

string(TOLOWER ${PROJECT_NAME} PROJECT_NAME_LOWER)
string(TOUPPER ${PROJECT_NAME} PROJECT_NAME_UPPER)

# handle version number
set(RX_PROJ_TAG "${PROJECT_NAME_UPPER}")
set(RX_WS "[ \t]")
file(READ "${CMAKE_SOURCE_DIR}/${PROJECT_NAME_LOWER}.h" _header_file)
string(REGEX MATCH "#${RX_WS}*define${RX_WS}+SISTOOL_?${RX_PROJ_TAG}_VER_MAJOR${RX_WS}+([0-9]+)" MAJOR_DUMMY ${_header_file})
set(_VERSION_MAJOR ${CMAKE_MATCH_1})
string(REGEX MATCH "#${RX_WS}*define${RX_WS}+SISTOOL_?${RX_PROJ_TAG}_VER_MINOR${RX_WS}+([0-9]+)" MINOR_DUMMY ${_header_file})
set(_VERSION_MINOR ${CMAKE_MATCH_1})
string(REGEX MATCH "#${RX_WS}*define${RX_WS}+SISTOOL_?${RX_PROJ_TAG}_VER_PATCH${RX_WS}+([0-9]+)" PATCH_DUMMY ${_header_file})
set(_VERSION_PATCH ${CMAKE_MATCH_1})

# set project version number here
set(PROJECT_VERSION_MAJOR ${_VERSION_MAJOR})
set(PROJECT_VERSION_MINOR ${_VERSION_MINOR})
set(PROJECT_VERSION_PATCH ${_VERSION_PATCH})
set(PROJECT_VERSION "${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}.${PROJECT_VERSION_PATCH}")

message(NOTICE "Generating CMake build scripts for ${PROJECT_NAME} ${PROJECT_VERSION}")


# adhere strictly to C and C++ standards plus extensions. These are actually
# useless since we do not compile anything; they merely state our intention.
set(CMAKE_C_STANDARD 11)
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS ON) # GNU extensions and POSIX standard
set(CMAKE_CXX_STANDARD 14)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)


# ##########################################################
# dependencies (required)

set(CLASP_REQUIRED_VERSION_ 0.14.0)
set(STLSoft_REQUIRED_VERSION_ 0.10.6)

find_package(CLASP ${CLASP_REQUIRED_VERSION_} REQUIRED)

message("-- CMake package CLASP found (version ${CLASP_VERSION}; ${CLASP_REQUIRED_VERSION_} requested)")

find_package(STLSoft ${STLSoft_REQUIRED_VERSION_} REQUIRED)

message("-- CMake package STLSoft found (version ${STLSoft_VERSION}; ${STLSoft_REQUIRED_VERSION_} requested)")

if(BUILD_TESTING)

	message("-- enabled building of tests ...")


	set(xTests_REQUIRED_VERSION_ 0.21.2)

	find_package(xTests ${xTests_REQUIRED_VERSION_} REQUIRED)

	message("-- CMake package xTests found (version ${xTests_VERSION}; ${xTests_REQUIRED_VERSION_} requested)")


	if(EXISTS ${CMAKE_SOURCE_DIR}/include)

		message("-- -- adding '${CMAKE_SOURCE_DIR}/include' to include-directories for testing")

		include_directories(${CMAKE_SOURCE_DIR}/include)
	endif()
endif(BUILD_TESTING)

# ##########################################################
# includes

if(UNIX AND APPLE)

	message("-- -- adding '/usr/local/include' to include-directories")

	include_directories(/usr/local/include)

	message("-- -- adding '/usr/local/lib' to lib-directories")

	link_directories(/usr/local/lib)
endif()



# ##########################################################
# install

# provides install directory variables as defined by the GNU Coding Standards.
include(GNUInstallDirs)


# ##########################################################
# tool - rstrip

add_executable(rstrip
	entry.c
	rstrip.c
)

target_compile_options(rstrip PRIVATE
	$<$<OR:$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>,$<CXX_COMPILER_ID:GNU>>:
		-Werror -Wall -Wextra -pedantic

		-Wno-ignored-qualifiers
		-Wno-incompatible-pointer-types-discards-qualifiers
		-Wno-unused-parameter
	>
	$<$<CXX_COMPILER_ID:MSVC>: /WX /W4>
)

target_link_libraries(rstrip
	clasp
	cstring
)

install(TARGETS rstrip
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)


# ##########################################################
# test (and test-only dependencies)

include(CTest)

if(BUILD_TESTING)

	message("-- enabled building of tests ...")

	add_executable(rstrip_test
		rstrip_test.cpp
		rstrip.c
	)

	target_compile_options(rstrip_test PRIVATE
		$<$<OR:$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>,$<CXX_COMPILER_ID:GNU>>:
			-Werror -Wall -Wextra -pedantic

			-Wno-deprecated-copy-with-user-provided-copy
			-Wno-ignored-qualifiers
			-Wno-incompatible-pointer-types-discards-qualifiers
			-Wno-unused-parameter
		>
		$<$<CXX_COMPILER_ID:MSVC>: /WX /W4>
	)

	target_link_libraries(rstrip_test
		clasp
		cstring
	)
endif(BUILD_TESTING)


# ############################## end of file ############################# #

