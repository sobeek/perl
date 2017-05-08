#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

typedef struct {
    SV * code;
    HV* metrics;
} METRIC;

SV * callback = (SV*)NULL;
HV* metrics = (HV*)NULL;

MODULE = Stats		PACKAGE = Stats

void new(code)
        SV* code;
    PPCODE:
        int count;
        printf ("1\n");
        METRIC* new_metric;
        SV* sv = newSVsv(new_metric->code);
        sv_setsv(sv, code);
        /* callback = code; there should be the end of new */
        printf ("2\n");
        ENTER;
        SAVETMPS;

        PUSHMARK(SP);
        call_sv(callback, G_DISCARD|G_NOARGS);
        XPUSHs(sv_2mortal(newSViv(9)));
        PUTBACK;
        count = call_pv("Stats::x", G_SCALAR);
        SPAGAIN;
        XPUSHs(sv_2mortal(newSViv(count)));

        FREETMPS;
        LEAVE;

HV* add(name, value)
        char* name;
        SV* value;
    CODE:

        printf ("name: %s\n", name);
        SV** store_res;
        HV* local_metrics = (HV *) sv_2mortal ((SV *) newHV ());
        /*SV* name_len_sv;
        int name_len;
        name_len_sv = newSVpv(name, 0);
        name_len = (int) name_len_sv;*/
        printf ("name: %s\n", name);
        if (hv_exists(metrics, name, strlen(name))) {
            printf ("OK\n");
        }
        else {
            SV* sv_value = newRV_inc((SV*) value);
            if (!(store_res = hv_store(local_metrics, name, strlen(name), sv_value, 0))) {
                printf ("NOT STORED!\n");
            }
            else {
                metrics = local_metrics;
            }
        }
        RETVAL = metrics;
        printf ("1\n");
    OUTPUT:
        RETVAL
