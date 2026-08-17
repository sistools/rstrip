#! /bin/bash

ScriptPath=$0
Dir=$(cd "$(dirname "$ScriptPath")" && pwd)
Basename=$(basename "$ScriptPath")

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

CMakeDir=${SIS_CMAKE_BUILD_DIR:-$Dir/_build}

case ${1:-} in
  "")
    ;;
  --help)
    [ -f "$Dir/.sis/script_info_lines.txt" ] && cat "$Dir/.sis/script_info_lines.txt"
    printf 'Generates HTML API documentation from public headers via Doxygen\n'
    exit 0
    ;;
  *)
    >&2 printf "%s: ${SisClr_Red}${SisClr_Bold}unrecognised argument %s${SisClr_None}; use --help for usage\n" "$ScriptPath" "$1"
    exit 1
    ;;
esac

cd "$Dir" || exit 1
command -v doxygen >/dev/null 2>&1 || {
  >&2 printf "%s: ${SisClr_Red}${SisClr_Bold}doxygen not found on PATH${SisClr_None}\n" "$ScriptPath"
  exit 1
}

mkdir -p "${CMakeDir}/doxygen"
{
  cat Doxyfile
  printf '\n# Output directory (overridden by %s)\n' "$Basename"
  printf 'OUTPUT_DIRECTORY = %s/doxygen\n' "$CMakeDir"
} | doxygen -

printf 'API documentation written to %s/doxygen/html/index.html\n' "$CMakeDir"
