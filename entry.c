
/* *********************************************************
 * includes
 */

#include "rstrip.h"

#include <clasp/clasp.h>

#include <sistools/common/usage.h>

#include <platformstl/filesystem/path_functions.h>

#include <errno.h>
#include <stdio.h>
#include <string.h>


/* *********************************************************
 * macros
 */

#define SIS_DOTSTAR(slice)                                  (int)(slice).len, (slice).ptr


/* *********************************************************
 * constants
 */

#define TOOLNAME                        "rstrip"
#define PROGRAM_VER_MAJOR               SISTOOL_RSTRIP_VER_MAJOR
#define PROGRAM_VER_MINOR               SISTOOL_RSTRIP_VER_MINOR
#define PROGRAM_VER_PATCH               SISTOOL_RSTRIP_VER_PATCH
#define PROGRAM_VER_ALPHABETA           SISTOOL_RSTRIP_VER_ALPHABETA
#define SUMMARY                         "Synesis System Tools"
#define COPYRIGHT                       "Copyright (c) 2020-2024 Synesis Information Systems"
#define DESCRIPTION                     "Strips any trailing whitespace, if present, from input lines"
#define USAGE                           TOOLNAME " [ ... flags/options ... ] [ { <input-file> | - } [ { <output-file> | - } ]]"

static clasp_specification_t const Specifications[] = {

    CLASP_GAP_SECTION("standard flags:"),

    CLASP_FLAG(NULL, "--help", "displays this help and terminates"),
    CLASP_FLAG(NULL, "--version", "displays version information and terminates"),

    CLASP_SPECIFICATION_ARRAY_TERMINATOR
};


/* *********************************************************
 * functions
 */

static
int
run(
    clasp_arguments_t const*        args
,   clasp_specification_t const*    specifications
)
{
    FILE*       in;
    FILE*       out;
    char const* in_path;
    char const* out_path;
    int         rc;
    int         flags = 0;

    clasp_argument_t const* firstUnusedFlagOrOption;

    if (clasp_flagIsSpecified(args, "--help")) {

        stcc_show_help(
            args
        ,   specifications
        ,   stdout
        ,   TOOLNAME
        ,   SUMMARY
        ,   COPYRIGHT
        ,   DESCRIPTION
        ,   USAGE
        ,   PROGRAM_VER_MAJOR, PROGRAM_VER_MINOR, PROGRAM_VER_PATCH, PROGRAM_VER_ALPHABETA
        );

        return EXIT_SUCCESS;
    }

    if (clasp_flagIsSpecified(args, "--version")) {

        stcc_show_version(
            stdout
        ,   TOOLNAME
        ,   PROGRAM_VER_MAJOR, PROGRAM_VER_MINOR, PROGRAM_VER_PATCH, PROGRAM_VER_ALPHABETA
        );

        return EXIT_SUCCESS;
    }

    clasp_checkAllFlags(args, specifications, &flags);

    if (0 != clasp_reportUnusedFlagsAndOptions(args, &firstUnusedFlagOrOption, 0)) {

        fprintf(stderr, "%.*s: unrecognised flag/option: '%.*s'\n", SIS_DOTSTAR(args->programName), SIS_DOTSTAR(firstUnusedFlagOrOption->resolvedName));

        return EXIT_FAILURE;
    }

    if (args->numValues < 1 ||
        0 == strcmp("-", args->values[0].value.ptr))
    {
        in_path     =   NULL;
        in          =   stdin;
    }
    else
    {
        in_path     =   args->values[0].value.ptr;
        in          =   fopen(in_path, "r");

        if (NULL == in)
        {
            fprintf(stderr, "%.*s: could not open file '%.*s': %s\n", SIS_DOTSTAR(args->programName), SIS_DOTSTAR(args->values[0].value), strerror(errno));

            return EXIT_FAILURE;
        }
    }

    if (args->numValues < 2 ||
        0 == strcmp("-", args->values[1].value.ptr))
    {
        out_path    =   NULL;
        out         =   stdout;
    }
    else
    {
        out_path    =   args->values[1].value.ptr;
        out         =   fopen(out_path, "w");

        if (NULL == out)
        {
            if (NULL != in_path)
            {
                fclose(in);
            }

            fprintf(stderr, "%.*s: could not open file '%.*s': %s\n", SIS_DOTSTAR(args->programName), SIS_DOTSTAR(args->values[1].value), strerror(errno));

            return EXIT_FAILURE;
        }
    }

    rc = sistool_rstrip(in, out, flags);

    if (NULL != in_path)
    {
        fclose(in);
    }

    if (NULL != out_path)
    {
        if (0 != fclose(out) &&
            EXIT_SUCCESS == rc)
        {
            fprintf(stderr, "%.*s: could not write to file '%s': %s\n", SIS_DOTSTAR(args->programName), out_path, strerror(errno));

            rc = EXIT_FAILURE;
        }
    }
    else
    {
        if (0 != fflush(out) &&
            EXIT_SUCCESS == rc)
        {
            fprintf(stderr, "%.*s: could not write to standard output: %s\n", SIS_DOTSTAR(args->programName), strerror(errno));

            rc = EXIT_FAILURE;
        }
    }

    return rc;
}

/* *********************************************************
 * main
 */

int main(int argc, char* argv[]) {

    stlsoft_C_string_slice_m_t const    programName     =   platformstl_C_get_directory_path_from_path(argv[0]);
    unsigned                            flags           =   0;
    clasp_specification_t const*        specifications  =   Specifications;
    clasp_diagnostic_context_t const*   ctxt            =   NULL;
    clasp_arguments_t const*            args            =   NULL;

    int const r =
        clasp_parseArguments(
            flags
        ,   argc
        ,   argv
        ,   specifications
        ,   ctxt
        ,   &args
        );

    if (0 != r) {

        fprintf(stderr, "%.*s: failed to initialise the command-line parsing libraries: %s\n", SIS_DOTSTAR(programName), strerror(r));

        return EXIT_FAILURE;
    } else {

        int xc = run(args, specifications);

        clasp_releaseArguments(args);

        return xc;
    }
}


/* ///////////////////// end of file //////////////////// */
