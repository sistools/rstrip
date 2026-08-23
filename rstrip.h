
#ifndef SIS_INCL_H_RSTRIP
#define SIS_INCL_H_RSTRIP

#define SISTOOL_RSTRIP_VER_MAJOR        0
#define SISTOOL_RSTRIP_VER_MINOR        1
#define SISTOOL_RSTRIP_VER_PATCH        2


/* *********************************************************
 * includes
 */

#include <stdio.h>


/* *********************************************************
 * API functions
 */

#ifdef __cplusplus
extern "C"
#endif /* __cplusplus */
int
sistool_rstrip(
    FILE*       in
,   FILE*       out
,   int         flags
);

#endif /* !SIS_INCL_H_RSTRIP */


/* ///////////////////// end of file //////////////////// */

