#! /bin/bash

ScriptPath=$0
Dir=$(cd "$(dirname "$ScriptPath")" && pwd)
Basename=$(basename "$ScriptPath")
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
    >&2 printf '%s: unrecognised argument %s; use --help for usage\n' "$ScriptPath" "$1"
    exit 1
    ;;
esac

cd "$Dir" || exit 1
command -v doxygen >/dev/null 2>&1 || {
  >&2 printf '%s: doxygen not found on PATH\n' "$ScriptPath"
  exit 1
}

mkdir -p "${CMakeDir}/doxygen"
{
  cat Doxyfile
  printf '\n# Output directory (overridden by %s)\n' "$Basename"
  printf 'OUTPUT_DIRECTORY = %s/doxygen\n' "$CMakeDir"
} | doxygen -

printf 'API documentation written to %s/doxygen/html/index.html\n' "$CMakeDir"
