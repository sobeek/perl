#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

#include "mylib/mylib.h"

#include "const-c.inc"

MODULE = Mytest2		PACKAGE = Mytest2

INCLUDE: const-xs.inc

TYPEMAP: <<END
const char *	T_PV
END

double
foo(a,b,c)
        int             a
        long            b
        const char *    c
    OUTPUT:
        RETVAL
