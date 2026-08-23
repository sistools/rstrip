
# ######################################################################## #
# File:     /CMakeLists.txt
#
# Purpose:  Top-level CMake lists file for rstrip
#
# Created:  2nd April 2020
# Updated:  23rd August 2026
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

# adhere strictly to C and C++ standards plus extensions. These are actually
# useless since we do not compile anything; they merely state our intention.
if(NOT CMAKE_C_STANDARD)

	set(CMAKE_C_STANDARD 17)
endif()
set(CMAKE_C_STANDARD_REQUIRED ON)
set(CMAKE_C_EXTENSIONS ON) # GNU extensions and POSIX standard
if(NOT CMAKE_CXX_STANDARD)

	set(CMAKE_CXX_STANDARD 17)
endif()
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)

if(MSVC)

	if(MSVC_VERSION GREATER_EQUAL 1914)

		add_compile_options("/Zc:__cplusplus")

		add_definitions(-D_SILENCE_CXX17_ITERATOR_BASE_CLASS_DEPRECATION_WARNING)
	endif()

	if(MSVC_VERSION LESS 1930)

		set(CMAKE_C_STANDARD 90)
		set(CMAKE_CXX_STANDARD 98)
	endif()

	if(MSVC_USE_MT)

		set(CMAKE_MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
	endif(MSVC_USE_MT)
else(MSVC)

	if(MSVC_USE_MT)

		# this here just to absorb warning about not using `MSVC_USE_MT` (to
		# enable **prepare_cmake.sh** to be simple)
	endif(MSVC_USE_MT)
endif(MSVC)


# ##########################################################
# dependencies, includes, options

# ################################################
# includes - 1

include(BuildType)
#[====[
include(LanguageFullVersion)
include(TargetMacros)
#]====]


# ################################################
# dependencies, features, and options


# ######################################
# options

option(BUILD_EXAMPLES "Build examples" ON)

option(BUILD_TESTING "Build tests" ON)


# ######################################
# features


# ######################################
# dependencies
#
# required:
# - CLASP;
# - cstring;
# - STLSoft;
#
# required if testing enabled:
# - Catch2 - required for testing;
# - xTests - required for testing;
#
# optional:


# ############################
# STLSoft
#
# NOTE: This is resolved before other dependencies because the imported
# CLASP::core target may reference STLSoft::STLSoft in its link interface,
# so that target must be available before find_package(CLASP) loads CLASP's
# target definitions.

if(DEFINED STLSOFT)

	message("-- STLSOFT provided as CMake variable with value '${STLSOFT}'")
	set(STLSOFT_INCLUDE_DIR "${STLSOFT}/include")
elseif(DEFINED ENV{STLSOFT})

	message("-- STLSOFT provided as environment variable with value '$ENV{STLSOFT}'")
	set(STLSOFT_INCLUDE_DIR "$ENV{STLSOFT}/include")
endif()

if(DEFINED STLSOFT_INCLUDE_DIR)

	if(NOT IS_DIRECTORY "${STLSOFT_INCLUDE_DIR}")

		message(FATAL_ERROR "STLSoft include directory not found: ${STLSOFT_INCLUDE_DIR}")
	endif()

	if(NOT TARGET STLSoft::STLSoft)

		add_library(STLSoft::STLSoft INTERFACE IMPORTED GLOBAL)
		set_target_properties(STLSoft::STLSoft PROPERTIES
			INTERFACE_INCLUDE_DIRECTORIES "${STLSOFT_INCLUDE_DIR}"
		)
	endif()
else()

	set(STLSoft_REQUIRED_VERSION_ 1.11.1)

	find_package(STLSoft ${STLSoft_REQUIRED_VERSION_} REQUIRED)

	message("-- CMake package STLSoft found (version ${STLSoft_VERSION}; ${STLSoft_REQUIRED_VERSION_} requested)")
endif()

if(DEFINED STLSOFT_INCLUDE_DIR)

	include_directories("${STLSOFT_INCLUDE_DIR}")
endif()


# ############################
# Catch2

if(BUILD_TESTING)

	set(Catch2_REQUIRED_VERSION_ 2.0...<3.0)

	find_package(Catch2 ${Catch2_REQUIRED_VERSION_} QUIET)

	if(Catch2_FOUND)

		message("-- CMake package Catch2 found (version ${Catch2_VERSION}; ${Catch2_REQUIRED_VERSION_} requested)")
	else(Catch2_FOUND)

		if(EXISTS ${CMAKE_SOURCE_DIR}/include)

			message("-- -- adding '${CMAKE_SOURCE_DIR}/include' to include-directories for testing")

			include_directories(${CMAKE_SOURCE_DIR}/include)
		endif()
	endif(Catch2_FOUND)
endif(BUILD_TESTING)


# ############################
# CLASP

set(CLASP_REQUIRED_VERSION_ 0.15)

find_package(CLASP ${CLASP_REQUIRED_VERSION_} REQUIRED)

message("-- CMake package CLASP found (version ${CLASP_VERSION}; ${CLASP_REQUIRED_VERSION_} requested)")


# ############################
# cstring

set(cstring_REQUIRED_VERSION_ 4)

find_package(cstring ${cstring_REQUIRED_VERSION_} REQUIRED)

message("-- CMake package cstring found (version ${cstring_VERSION}; ${cstring_REQUIRED_VERSION_} requested)")

	find_package(Catch2 ${Catch2_REQUIRED_VERSION_} QUIET)

# ############################
# xTests

if(BUILD_TESTING)

	set(xTests_REQUIRED_VERSION_ 0.26.4)

	find_package(xTests ${xTests_REQUIRED_VERSION_} REQUIRED)

	message("-- CMake package xTests found (version ${xTests_VERSION}; ${xTests_REQUIRED_VERSION_} requested)")
endif(BUILD_TESTING)


# ################################################
# includes - 2

include(CMakePackageConfigHelpers)
if(BUILD_TESTING)

	include(CTest)
endif(BUILD_TESTING)
include(GNUInstallDirs)


# ##########################################################
# tool

add_executable(${PROJECT_NAME_LOWER}
	entry.c
	${PROJECT_NAME_LOWER}.c
)

target_compile_options(${PROJECT_NAME_LOWER}
	PRIVATE
		$<$<OR:$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>,$<CXX_COMPILER_ID:GNU>>:
			-Werror -Wall -Wextra -pedantic

			-Wno-ignored-qualifiers
			-Wno-incompatible-pointer-types-discards-qualifiers
			-Wno-unused-parameter
		>
		$<$<CXX_COMPILER_ID:MSVC>:
			/WX /W4

			/wd4996
		>
)

target_link_libraries(${PROJECT_NAME_LOWER}
	CLASP::core
	cstring::core
)

install(TARGETS ${PROJECT_NAME_LOWER}
	RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)

install(FILES
	doc/${PROJECT_NAME_LOWER}.1
	DESTINATION ${CMAKE_INSTALL_MANDIR}/man1
)


# ################################################
# examples


# ################################################
# tests

if(BUILD_TESTING)

	message("-- enabled building of tests ...")

	add_executable(${PROJECT_NAME_LOWER}_test
		${PROJECT_NAME_LOWER}_test.cpp
		${PROJECT_NAME_LOWER}.c
	)

	target_compile_options(${PROJECT_NAME_LOWER}_test
		PRIVATE
			$<$<OR:$<CXX_COMPILER_ID:Clang>,$<CXX_COMPILER_ID:AppleClang>,$<CXX_COMPILER_ID:GNU>>:
				-Werror -Wall -Wextra -pedantic

				-Wno-deprecated-copy-with-user-provided-copy
				-Wno-ignored-qualifiers
				-Wno-incompatible-pointer-types-discards-qualifiers
				-Wno-unused-parameter
			>
			$<$<CXX_COMPILER_ID:MSVC>:
				/WX /W4

				/wd4996
			>
	)

	target_link_libraries(${PROJECT_NAME_LOWER}_test
		$<IF:$<STREQUAL:${Catch2_FOUND},>,,Catch2::Catch2>
		CLASP::core
		cstring::core
		$<$<STREQUAL:${STLSOFT_INCLUDE_DIR},>:STLSoft::STLSoft>
		xTests::core
	)
else(BUILD_TESTING)

	message("-- disabled building of tests - define BUILD_TESTING to enable")
endif(BUILD_TESTING)


# ##########################################################
# completion

message(NOTICE "Generating CMake build scripts for ${PROJECT_NAME} ${PROJECT_VERSION}, for C${CMAKE_C_STANDARD} C++${CMAKE_CXX_STANDARD}, with build type ${CMAKE_BUILD_TYPE}")


# ############################## end of file ############################# #
