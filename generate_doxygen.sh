#! /bin/bash

ScriptPath=$0
Dir=$(cd "$(dirname "$ScriptPath")" && pwd)
Basename=$(basename "$ScriptPath")

CMakeDir=${SIS_CMAKE_BUILD_DIR:-$Dir/_build}
ProjectNameFile="$Dir/.sis/project_name.txt"
ProjectName=$(tr -d '[:space:]' < "$ProjectNameFile")

DoxygenOptions=()


# ##########################################################
# colours

if [ -n "${TERM:-}" ] && [ -t 1 ] && command -v tput >/dev/null 2>&1; then

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
    --quiet|-q)

      DoxygenOptions=(-q)
      ;;
    --help)

      [ -f "$Dir/.sis/script_info_lines.txt" ] && cat "$Dir/.sis/script_info_lines.txt"
      cat << EOF
Generates HTML API documentation from public headers via Doxygen

$ScriptPath [ ... flags/options ... ]

Flags/options:

    behaviour:

    -q
    --quiet
        causes the flag -q to be passed to Doxygen, which will then act as
        if QUIET=YES has been set


    standard flags:

    --help
        displays this help and terminates

Environment:

    SIS_CMAKE_BUILD_DIR
        CMake build directory (default: <project>/_build); documentation is
        written to <build-dir>/doxygen/html/

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

echo "Executing Doxygen for ${SisClr_Blue}${SisClr_Bold}${ProjectName}${SisClr_None} (in ${SisClr_Blue}${SisClr_Bold}${CMakeDir}${SisClr_None})"

command -v doxygen >/dev/null 2>&1 || {

  >&2 printf "%s: ${SisClr_Red}${SisClr_Bold}doxygen not found on PATH${SisClr_None}\n" "$ScriptPath"

  exit 1
}

mkdir -p "${CMakeDir}/doxygen" || exit 1

{
  cat Doxyfile
  printf '\n# Output directory (overridden by %s)\n' "$Basename"
  printf 'OUTPUT_DIRECTORY = %s/doxygen\n' "$CMakeDir"
} | doxygen "${DoxygenOptions[@]}" -

printf 'API documentation written to %s/doxygen/html/index.html\n' "$CMakeDir"


# ############################## end of file ############################# #
