
/* *********************************************************
 * includes
 */

#include "rstrip.h"

#include <cstring/cstring.h>

#include <ctype.h>
#include <errno.h>
#include <stdlib.h>
#include <string.h>


/* *********************************************************
 * API functions
 */

int
sistool_rstrip(
    FILE*       in
,   FILE*       out
,   int         flags
)
{
    int         ch;
    cstring_t   cs = { 0 };
    CSTRING_RC  rc = CSTRING_RC_SUCCESS;

    ((void)&flags);

    for (; EOF != (ch = fgetc(in)); )
    {
        if ('\n' == ch)
        {
            fputc(ch, out);

            rc = cstring_truncate(&cs, 0);

            if (CSTRING_RC_SUCCESS != rc)
            {
                goto cstring_fail;
            }
        }
        else
        {
            if (isspace(ch))
            {
                cstring_appendLen(&cs, (char*)&ch, 1);
            }
            else
            {
                if (0 != cs.len)
                {
                    CSTRING_RC const rc2 = cstring_write(out, &cs, NULL);

                    if (CSTRING_RC_SUCCESS != rc2)
                    {
                        goto cstring_fail;
                    }

                    cstring_truncate(&cs, 0);
                }

                fputc(ch, out);
            }
        }
    }

    cstring_destroy(&cs);

    return EXIT_SUCCESS;

cstring_fail:

    cstring_destroy(&cs);

    switch (rc)
    {
    case CSTRING_RC_IOERROR:

        return EIO;
    case CSTRING_RC_OUTOFMEMORY:

        return ENOMEM;
    default:

        return -1;
    }
}


/* ///////////////////// end of file //////////////////// */

