#! /bin/bash

ScriptPath=$0
Dir=$(cd "$(dirname "$ScriptPath")" && pwd)
Basename=$(basename "$ScriptPath")

CMakeDir=${SIS_CMAKE_BUILD_DIR:-$Dir/_build}
if [[ -n "$MSYSTEM" ]]; then

  DefaultMakeCmd=mingw32-make.exe
  MinGW=1
else

  DefaultMakeCmd=make
fi
MakeCmd=${SIS_CMAKE_MAKE_COMMAND:-${SIS_CMAKE_COMMAND:-$DefaultMakeCmd}}
ProjectNameFile="$Dir/.sis/project_name.txt"
ProjectName=$(tr -d '[:space:]' < "$ProjectNameFile")

Configuration=Release
CStandard=
MSVC_MT=0
MinGW="${MinGW:=0}"
RunMake=0
STLSoftDirGiven=
TestingDisabled=0
VerboseMakefile=0


# ##########################################################
# colours

if command -v tput > /dev/null; then

  SisClr_Blue=${FG_BLUE:-$(tput setaf 4)}
  SisClr_Red=${FG_RED:-$(tput setaf 1)}
  SisClr_Bold=${FD_BOLD:-$(tput bold)}
  SisClr_None=${FD_NONE:-$(tput sgr0)}
else

  SisClr_Blue=
  SisClr_Red=
  SisClr_Bold=
  SisClr_None=
fi


# ##########################################################
# command-line handling

while [[ $# -gt 0 ]]; do

  case $1 in
    --c-standard)

      shift
      CStandard=$1
      case $CStandard in
        99|11|17|23)
          ;;
        *)

          >&2 echo "$ScriptPath: ${SisClr_Red}${SisClr_Bold}invalid C standard '$CStandard'${SisClr_None}; expected 99, 11, 17, or 23"

          exit 1
          ;;
      esac
      ;;
    --cmake-verbose-makefile|-v)

      VerboseMakefile=1
      ;;
    --debug-configuration|-d)

      Configuration=Debug
      ;;
    --disable-testing|-T)

      TestingDisabled=1
      ;;
    --mingw)

      MinGW=1
      ;;
    --msvc-mt)

      MSVC_MT=1
      ;;
    --run-make|-m)

      RunMake=1
      ;;
    --stlsoft-root-dir|-s)

      shift
      STLSoftDirGiven=$1
      ;;
    --help)

      [ -f "$Dir/.sis/script_info_lines.txt" ] && cat "$Dir/.sis/script_info_lines.txt"
      cat << EOF
Creates/reinitialises the CMake build script(s)

$ScriptPath [ ... flags/options ... ]

Flags/options:

    behaviour:

    --c-standard {99|11|17|23}
        sets CMAKE_C_STANDARD (default is 11)

    -v
    --cmake-verbose-makefile
        configures CMake to run verbosely (by setting CMAKE_VERBOSE_MAKEFILE
        to be ON)

    -d
    --debug-configuration
        use Debug configuration (by setting CMAKE_BUILD_TYPE=Debug). Default
        is to use Release

    -T
    --disable-testing
        disables building of tests (by setting BUILD_TESTING=OFF)

    --mingw
        uses explicitly the "MinGW Makefiles" generator, and defaults the
        make-command to "mingw32-make.exe"

    --msvc-mt
        when using Visual C++ (MSVC), the static runtime library will be
        selected; the default is the dynamic runtime library

    -m
    --run-make
        executes make after a successful running of CMake

    -s <dir>
    --stlsoft-root-dir <dir>
        specifies the STLSoft root-directory, which will be passed to CMake
        as the variable STLSOFT, and which will override the environment
        variable STLSOFT (if present)


    standard flags:

    --help
        displays this help and terminates

EOF

      exit 0
      ;;
    *)

      >&2 echo "$ScriptPath: ${SisClr_Red}${SisClr_Bold}unrecognised argument '$1'${SisClr_None}; use --help for usage"

      exit 1
      ;;
  esac

  shift
done


# ##########################################################
# main()

mkdir -p $CMakeDir || exit 1

cd $CMakeDir

echo "Executing CMake for ${SisClr_Blue}${SisClr_Bold}${ProjectName}${SisClr_None} (in ${SisClr_Blue}${SisClr_Bold}${CMakeDir}${SisClr_None})"

if [ -z "$CStandard" ]; then CMakeCStandardVariable="" ; else CMakeCStandardVariable="-DCMAKE_C_STANDARD=$CStandard" ; fi
if [ $MSVC_MT -eq 0 ]; then CMakeMsvcMtFlag="OFF" ; else CMakeMsvcMtFlag="ON" ; fi
if [ -z "$STLSoftDirGiven" ]; then CMakeSTLSoftVariable="" ; else CMakeSTLSoftVariable="-DSTLSOFT=$STLSoftDirGiven/" ; fi
if [ $TestingDisabled -eq 0 ]; then CMakeBuildTestingFlag="ON" ; else CMakeBuildTestingFlag="OFF" ; fi
if [ $VerboseMakefile -eq 0 ]; then CMakeVerboseMakefileFlag="OFF" ; else CMakeVerboseMakefileFlag="ON" ; fi

if [ $MinGW -ne 0 ]; then

  cmake \
    $CMakeCStandardVariable \
    $CMakeSTLSoftVariable \
    -DBUILD_TESTING:BOOL=$CMakeBuildTestingFlag \
    -DCMAKE_BUILD_TYPE=$Configuration \
    -G "MinGW Makefiles" \
    -S $Dir \
    -B $CMakeDir \
    || (cd ->/dev/null ; exit 1)
else

  cmake \
    $CMakeCStandardVariable \
    $CMakeSTLSoftVariable \
    -DBUILD_TESTING:BOOL=$CMakeBuildTestingFlag \
    -DCMAKE_BUILD_TYPE=$Configuration \
    -DCMAKE_VERBOSE_MAKEFILE:BOOL=$CMakeVerboseMakefileFlag \
    -DMSVC_USE_MT:BOOL=$CMakeMsvcMtFlag \
    -S $Dir \
    -B $CMakeDir \
    || (cd ->/dev/null ; exit 1)
fi

status=0

if [ $RunMake -ne 0 ]; then

  echo "Executing build (via command \`${SisClr_Blue}${SisClr_Bold}$MakeCmd${SisClr_None}\`)"

  $MakeCmd
  status=$?
fi

cd ->/dev/null

if [ $VerboseMakefile -ne 0 ]; then

  echo -e "contents of $CMakeDir:"
  ls -al $CMakeDir
fi

exit $status


# ############################## end of file ############################# #
