#! /bin/bash

ScriptPath=$0
Dir=$(cd $(dirname "$ScriptPath"); pwd)
Basename=$(basename "$ScriptPath")
CMakeDir=${SIS_CMAKE_BUILD_DIR:-$Dir/_build}
if [[ -n "$MSYSTEM" ]]; then

  DefaultMakeCmd=mingw32-make.exe
  MinGW=1
else

  DefaultMakeCmd=make
fi
MakeCmd=${SIS_CMAKE_MAKE_COMMAND:-${SIS_CMAKE_COMMAND:-$DefaultMakeCmd}}
ProjectName=$(cat "$Dir/.sis/project_name.txt")

ListOnly=0
RunMake=1
Verbose=0


# ##########################################################
# operating environment detection

OsName="$(uname -s)"
case "${OsName}" in
  CYGWIN*|MINGW*|MSYS_NT*)

    # Restrict to *.exe so intermediate *.obj under CMakeFiles are not matched
    FindTestNameExpr=( -name "*${ProjectName}*test*.exe" )
    ;;
  *)

    FindTestNameExpr=( -name "*${ProjectName}*test*" )
    ;;
esac


# ##########################################################
# command-line handling

while [[ $# -gt 0 ]]; do

  case $1 in
    --list-only|-l)

      ListOnly=1
      ;;
    --no-make|-M)

      RunMake=0
      ;;
    --verbose|-v)

      Verbose=1
      ;;
    --help)

      [ -f "$Dir/.sis/script_info_lines.txt" ] && cat "$Dir/.sis/script_info_lines.txt"
      cat << EOF
Runs all (matching) component and unit test programs

$ScriptPath [ ... flags/options ... ]

Flags/options:

    behaviour:

    -l
    --list-only
        lists the target programs but does not execute them

    -M
    --no-make
        does not execute CMake and make before running tests

    -v
    --verbose
        lists each test program before executing it


    standard flags:

    --help
        displays this help and terminates

EOF

      exit 0
      ;;
    *)

      >&2 echo "$ScriptPath: unrecognised argument '$1'; use --help for usage"

      exit 1
      ;;
  esac

  shift
done


# ##########################################################
# main()

status=0

# Canonicalise build-dir path (important on Windows Git Bash, where
# SIS_CMAKE_BUILD_DIR may arrive with drive-letter backslashes).
if [ -d "$CMakeDir" ]; then

  CMakeDir=$(cd "$CMakeDir" && pwd)
fi

if [ $RunMake -ne 0 ]; then

  if [ $ListOnly -eq 0 ]; then

    echo "Executing build (via command \`$MakeCmd\`) and then running all component and unit test programs"

    mkdir -p "$CMakeDir" || exit 1

    cd "$CMakeDir"

    $MakeCmd
    status=$?

    cd ->/dev/null
  fi
else

  if [ ! -d "$CMakeDir" ] || [ ! -f "$CMakeDir/CMakeCache.txt" ] || [ ! -d "$CMakeDir/CMakeFiles" ]; then

    >&2 echo "$ScriptPath: cannot run in '--no-make' mode without a previous successful build step"
  fi
fi

if [ $status -eq 0 ]; then

  if [ $ListOnly -ne 0 ]; then

    echo "Listing all component and unit test programs"
  else

    echo "Running all component and unit test programs"
  fi

  for f in $(find $CMakeDir -type f '(' "${FindTestNameExpr[@]}" ')' -exec test -x {} \; -print)
  do

    if [ $ListOnly -ne 0 ]; then

      echo "would execute $f:"

      continue
    fi

    if [ $Verbose -ne 0 ]; then

      echo "executing $f:"
    fi

    if "$f"; then

      :
    else

      status=$?

      break 1
    fi
  done
fi

exit $status


# ############################## end of file ############################# #
