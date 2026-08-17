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
    --help)

      [ -f "$Dir/.sis/script_info_lines.txt" ] && cat "$Dir/.sis/script_info_lines.txt"
      cat << EOF
Executes CMake-generated artefacts to clean project

$ScriptPath [ ... flags/options ... ]

Flags/options:

    behaviour:


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

if [ ! -d "$CMakeDir" ]; then

  >&2 echo "$ScriptPath: ${SisClr_Red}${SisClr_Bold}CMake build directory '$CMakeDir' not found${SisClr_None} so nothing to do; use script 'prepare_cmake.sh' if you wish to prepare CMake artefacts"

  exit 1
else

  cd $CMakeDir

  if [ ! -f "$CMakeDir/Makefile" ]; then

    >&2 echo "$ScriptPath: ${SisClr_Red}${SisClr_Bold}CMake build directory '$CMakeDir' does not contain expected file 'Makefile'${SisClr_None}, so a clean cannot be performed. It is recommended that you remove all CMake artefacts using script 'remove_cmake_artefacts.sh' followed by regeneration via 'prepare_cmake.sh'"

    cd ->/dev/null

    exit 1
  else

    echo "Cleaning ${SisClr_Blue}${SisClr_Bold}${ProjectName}${SisClr_None} (via command \`${SisClr_Blue}${SisClr_Bold}$MakeCmd clean${SisClr_None}\`)"

    $MakeCmd clean
    status=$?

    cd ->/dev/null

    exit $status
  fi
fi


# ############################## end of file ############################# #
