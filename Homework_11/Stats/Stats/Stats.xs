#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

typedef struct {
    SV* code;
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

        METRIC * self = malloc( sizeof(METRIC) );
        self->code = code;
        self->metrics = newHV();
        //hv_store(self->metrics, "anc", 3, newSViv(7), 0);
        // Convert pointer to size_t
        size_t point_iv = PTR2IV(self);
        // Convert size_t to SV*
        SV* sv = newSViv(point_iv);
        // Create reference to SV*
        SV* svrv = newRV_inc(sv);
        // Create Object
        SV* obj = sv_bless(svrv, gv_stashpv(SvPV_nolen(ST(0)), 1));
        printf ("2\n");
/* THE GREATEST CODE EVER */
        METRIC* x;
        SV * point = SvRV(obj);
        size_t z = SvIV (point);
        x = INT2PTR(METRIC*, z);
        XPUSHs(sv_2mortal(obj)); // x - это наша структура
/*------------------------*/
        //RETVAL = obj;
        //printf ("3\n");
        /*
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
*/


HV* add(self, name, value)
        SV* self;
        char* name;
        SV* value;
    CODE:
        int count;
        printf ("name: %s\n", name);
        //HV* local_metrics = (HV *) sv_2mortal ((SV *) newHV ());
        //printf ("name: %s\n", name);
        METRIC* x;
        SV * ptr_to_self = SvRV(self);
        size_t z = SvIV (ptr_to_self);
        x = INT2PTR(METRIC*, z);
        //RETVAL = x->metrics;

        AV* settings = newAV();

        bool avg_flag = FALSE;
/*
        dSP;

        ENTER;
        SAVETMPS;
        PUSHMARK(SP);

        PUTBACK;
*/
        count = call_sv(x->code, G_ARRAY);
        SPAGAIN;

        for (int j = 0; j < count; j++) {
            av_push(settings, POPs);
        }


        /*for (int j = 0; j < count; j++) {
            STRLEN len;
            SV *sv = av_shift(settings);
            char *s = SvPV(sv, len);
            printf("%s\n", s);
        }*/

        /*PUTBACK;
        FREETMPS;
        LEAVE; */

        if (hv_exists(x->metrics, name, strlen(name))) {
            printf("RENEW\n");

            SV* ptr_to_current_metric_values = *hv_fetch(x->metrics, name, strlen(name), 0);
            size_t size_current_metric_values = SvIV (ptr_to_current_metric_values);
            HV* current_metric_values = INT2PTR (HV*, size_current_metric_values);

            RETVAL = current_metric_values;
            //HV* current_metric_values = *hv_fetch(x->metrics, name, strlen(name), 0);
            //SV* ptr_to_current_metric_values = *(hv_fetch(current_metric, sum, strlen(sum), 0));
            //size_t size_sum_value = SvIV (ptr_to_current_metric_values);
            //HV* current_metric = INT2PTR (HV*, size_sum_value);

            size_t size_t_of_current_value = SvIV (value);
            int value = INT2PTR (int, size_t_of_current_value);

            printf("value = %d\n", value);

            for (int i = 0; i < count; i++) {
                STRLEN len;
                SV *sv = av_shift(settings);
                char *s = SvPV(sv, len);
                //char *s_const = s;
                printf ("%d\n", i);
                printf("%s\n", s);
                if (!strcmp (s, "sum")) {
                    printf("%s!\n", s);

                    SV* ptr_to_sum_value = *(hv_fetch(current_metric_values, s, strlen(s), 0));
                    size_t size_sum_value = SvIV (ptr_to_sum_value);
                    int current_sum_value = INT2PTR (int, size_sum_value);

                    current_sum_value += value;
                    printf ("cur = %d, val = %d\n", current_sum_value, value);

                    SV* current_sum = newSViv(current_sum_value);

                    hv_store(current_metric_values, s, strlen(s), current_sum, 0);
                }
                if (!strcmp (s, "cnt")) {
                    printf("%s!!\n", s);

                    //char *sum = "cnt";

                    SV* ptr_to_cnt_value = *(hv_fetch(current_metric_values, s, strlen(s), 0));
                    size_t size_cnt_value = SvIV (ptr_to_cnt_value);
                    int current_cnt_value = INT2PTR (int, size_cnt_value);

                    //size_t size_t_of_current_value = SvIV (value);
                    //int value = INT2PTR (int, size_t_of_current_value);

                    current_cnt_value++;// += value;
                    printf ("cur = %d\n", current_cnt_value);

                    SV* current_cnt = newSViv(current_cnt_value);

                    hv_store(current_metric_values, s, strlen(s), current_cnt, 0);
                    //hv_store(current_metric, s, strlen(s), unit, 0);
                }
                if (!strcmp (s, "max")) {
                    printf("%s!!!\n", s);

                    SV* ptr_to_max_value = *(hv_fetch(current_metric_values, s, strlen(s), 0));
                    size_t size_max_value = SvIV (ptr_to_max_value);
                    int current_max_value = INT2PTR (int, size_max_value);

                    //size_t size_t_of_current_value = SvIV (value);
                    //int value = INT2PTR (int, size_t_of_current_value);

                    current_max_value = current_max_value > value ? current_max_value : value;

                    SV* current_max = newSViv(current_max_value);
                    hv_store(current_metric_values, s, strlen(s), current_max, 0);
                    //hv_store(current_metric, s, strlen(s), value, 0);
                }
                if (!strcmp (s, "min")) {
                    printf("%s!!!\n", s);

                    SV* ptr_to_min_value = *(hv_fetch(current_metric_values, s, strlen(s), 0));
                    size_t size_min_value = SvIV (ptr_to_min_value);
                    int current_min_value = INT2PTR (int, size_min_value);

                    //size_t size_t_of_current_value = SvIV (value);
                    //int value = INT2PTR (int, size_t_of_current_value);

                    printf("__%s!!!\n", s);

                    current_min_value = value > current_min_value ? current_min_value : value;

                    printf ("cur = %d, val = %d\n", current_min_value, value);

                    SV* current_min = newSViv(current_min_value);
                    hv_store(current_metric_values, s, strlen(s), current_min, 0);
                    //hv_store(current_metric, s, strlen(s), value, 0);
                }
                if (!strcmp (s, "avg")) {
                    printf("%s!!\n", s);
                    avg_flag = TRUE;
                }

                //TODO: calculate avg
            }
            printf ("OK\n");
            //hv_store(x->metrics, name, strlen(name), newRV_inc((SV*) current_metric_values), 0);
            //x->metrics = current_metric_values;
            //RETVAL = x->metrics;
        }
        else {
            printf("INITIALIZE...\n");
            HV* metric_values = newHV();
            SV* unit = newSViv(1);

            printf ("count = %d\n", count);
            for (int i = 0; i < count; i++) {

                STRLEN len;
                printf ("%d\n", i);
                SV *sv = av_shift(settings);
                printf ("%d\n", i);
                char *s = SvPV(sv, len);

                printf ("%d\n", i);
                printf("%s\n", s);
                if (!strcmp (s, "sum")) {
                    printf("%s!\n", s);
                    hv_store(metric_values, s, strlen(s), value, 0);
                }
                if (!strcmp (s, "cnt")) {
                    printf("%s!!\n", s);
                    hv_store(metric_values, s, strlen(s), unit, 0);
                }
                if (!strcmp (s, "min") || !strcmp (s, "max")) {
                    printf("%s!!!\n", s);
                    hv_store(metric_values, s, strlen(s), value, 0);
                }
                if (!strcmp (s, "avg")) {
                    printf("%s!!\n", s);
                    avg_flag = TRUE;
                }
            }
            if (avg_flag) {
                char *sum = "sum";
                char *cnt = "cnt";
                int _sum;
                int _count;
                //printf ("1\n");
                SV* ptr_to_sum_value = *(hv_fetch(metric_values, sum, strlen(sum), 0));
                SV* ptr_to_cnt_value = *(hv_fetch(metric_values, cnt, strlen(cnt), 0));
                //printf ("2\n");

                size_t size_sum_value = SvIV (ptr_to_sum_value);
                _sum = INT2PTR (int, size_sum_value);

                //printf ("%d\n", _sum);
                size_t size_count_value = SvIV (ptr_to_cnt_value);
                _count = INT2PTR (int, size_count_value);
                //printf ("%d\n", _count);
                //_sum = INT2PTR (int, size_sum_value);
                double _avg = _sum / _count;
                SV* avg = newSVnv(_avg);
                hv_store(metric_values, "avg", 3, avg, 0);
            }
            //SV* q = newRV_inc((SV*) metric_values);
            hv_store(x->metrics, name, strlen(name), newRV_inc((SV*) metric_values), 0);
            //x->metrics = metric_values;
            RETVAL = x->metrics;
        }


        /*SV* name_len_sv;
        int name_len;
        name_len_sv = newSVpv(name, 0);
        name_len = (int) name_len_sv;
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
        printf ("1\n"); */
    OUTPUT:
        RETVAL
