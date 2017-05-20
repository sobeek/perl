#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

typedef struct {
    SV* code;
    HV* metrics;
    //AV* settings;
} METRIC;

typedef struct {
    AV* metrics;
} METRIC_ARRAY;

//METRIC_ARRAY * created_metrics = malloc( sizeof(METRIC_ARRAY) );
//created_metrics->metrics = newAV();

//METRIC * metrics[1];
bool flag = FALSE;

MODULE = Stats		PACKAGE = Stats

void new(code)
        SV* code;
    PPCODE:
        int count;
        printf ("1\n");

        METRIC * self = malloc( sizeof(METRIC) );
        self->code = code;
        self->metrics = newHV();
        //self->settings = newAV();
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
/* GETTING THE STRUCTURE FIELDS
        METRIC* x;
        SV * sv_obj = SvRV(obj);
        size_t z = SvIV (sv_obj);
        x = INT2PTR(METRIC*, z);
 */
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

void calculate_avg (current_metric_values)
        HV* current_metric_values;
    CODE:
        char *sum = "sum";
        char *cnt = "cnt";
        int _sum;
        int _count;
        //printf ("1\n");
        SV* ptr_to_sum_value = *(hv_fetch(current_metric_values, sum, strlen(sum), 0));
        SV* ptr_to_cnt_value = *(hv_fetch(current_metric_values, cnt, strlen(cnt), 0));
        //printf ("2\n");

        //size_t size_sum_value =
        _sum = SvIV (ptr_to_sum_value);

        //printf ("%d\n", _sum);
        //size_t size_count_value =
        _count = SvIV (ptr_to_cnt_value);
        //printf ("%d\n", _count);
        //_sum = INT2PTR (int, size_sum_value);
        double _avg = _sum / _count;
        SV* avg = newSVnv(_avg);
        hv_store(current_metric_values, "avg", 3, avg, 0);

HV* stat(self)
        SV* self
    CODE:
        METRIC* calculated_metrics;
        SV * calculated_metrics_sv = SvRV(self);
        size_t size_calculated_metrics = SvIV (calculated_metrics_sv);
        calculated_metrics = INT2PTR(METRIC*, size_calculated_metrics);

        RETVAL = calculated_metrics->metrics;
        char * key;
        char * _settings = "_settings";

        I32 hash_keys_number = hv_iterinit(calculated_metrics->metrics);
        for (int i = 1; i < hash_keys_number; i++) {
            HE* x = hv_iternext(calculated_metrics->metrics);
            key = hv_iterkey(x, &hash_keys_number);
            printf("KEY: %s\n", key);

            SV* ptr_to_current_metric_values = *hv_fetch(calculated_metrics->metrics, key, strlen(key), 0);
            size_t size_current_metric_values = SvIV (ptr_to_current_metric_values);
            HV* current_metric_values = INT2PTR (HV*, size_current_metric_values);

            SV* sv_settings = *hv_fetch(current_metric_values, _settings, strlen(_settings), 0);
            size_t size_settings = SvIV(sv_settings);
            AV* settings = INT2PTR(AV*, size_settings);
            //
            if (-1 == av_len(settings)) {
                printf("NULL\n");
                //hv_undef(current_metric_values);
                hv_delete(calculated_metrics->metrics, key, strlen(key), 0);
                continue;
            }
            else {
                printf("NOT NULL\n");
            }
            //hv_fetch(x->metrics, name, strlen(name), 0);
        }
        RETVAL = calculated_metrics->metrics;

    OUTPUT:
        RETVAL

HV* add(self, name, sv_value)
        SV* self;
        char* name;
        SV* sv_value;
    CODE:
        int count;
        char * settings_item;
        printf ("name: %s\n", name);
        METRIC* x;
        SV * ptr_to_self = SvRV(self);
        size_t z = SvIV (ptr_to_self);
        x = INT2PTR(METRIC*, z);
        //RETVAL = x->settings;

        //AV* settings = newAV();

        bool avg_flag = FALSE;
/*
        dSP;

        ENTER;
        SAVETMPS;
        PUSHMARK(SP);

        PUTBACK;
*/

        /*for (int j = 0; j < count; j++) {
            STRLEN len;
            SV *sv = av_shift(settings);
            char *s = SvPV(sv, len);
            printf("%s\n", s);
        }*/

        if (hv_exists(x->metrics, name, strlen(name))) {
            printf("UPDATE\n");

            SV* ptr_to_current_metric_values = *hv_fetch(x->metrics, name, strlen(name), 0);
            size_t size_current_metric_values = SvIV (ptr_to_current_metric_values);
            HV* current_metric_values = INT2PTR (HV*, size_current_metric_values);

            RETVAL = x->metrics;

            //HV* current_metric_values = *hv_fetch(x->metrics, name, strlen(name), 0);
            //SV* ptr_to_current_metric_values = *(hv_fetch(current_metric, sum, strlen(sum), 0));
            //size_t size_sum_value = SvIV (ptr_to_current_metric_values);
            //HV* current_metric = INT2PTR (HV*, size_sum_value);

            int value = SvIV (sv_value);
            //count = (int) av_len(x->settings) + 1;
            printf ("upd: %d\n", count);
            printf("value = %d\n", value);

            //for (int i = 0; i < 5; i++) {
                //STRLEN len;
                //SV *sv = newSVsv(*(av_fetch(x->settings, i, 1)));
                //printf ("upd: %d!!!\n", i);
                // = av_shift(settings);
                //char *s = SvPV(sv, len);
                //printf ("upd: %d\n", i);
                //printf("upd: %s\n", s);
                //if (!strcmp (s, "sum")) {


                /*---SUM---*/

                {
                    //printf("upd: %s!\n", s);
                    settings_item = "sum";
                    SV* ptr_to_sum_value = *(hv_fetch(current_metric_values, settings_item, strlen(settings_item), 0));
                    int current_sum_value = SvIV (ptr_to_sum_value);

                    current_sum_value += value;
                    printf ("cur = %d, val = %d\n", current_sum_value, value);

                    SV* current_sum = newSViv(current_sum_value);

                    hv_store(current_metric_values, settings_item, strlen(settings_item), current_sum, 0);
                }

                //if (!strcmp (s, "cnt"))
                /*---CNT---*/
                {
                    //printf("upd: %s!!\n", s);
                    settings_item = "cnt";
                    SV* ptr_to_cnt_value = *(hv_fetch(current_metric_values, settings_item, strlen(settings_item), 0));
                    int current_cnt_value = SvIV (ptr_to_cnt_value);

                    current_cnt_value++;
                    printf ("cur = %d\n", current_cnt_value);

                    SV* current_cnt = newSViv(current_cnt_value);

                    hv_store(current_metric_values, settings_item, strlen(settings_item), current_cnt, 0);
                }

                //if (!strcmp (s, "max"))
                {
                    //printf("upd: %s!!!\n", s);
                    settings_item = "max";
                    SV* ptr_to_max_value = *(hv_fetch(current_metric_values, settings_item, strlen(settings_item), 0));
                    int current_max_value = SvIV (ptr_to_max_value);

                    current_max_value = current_max_value > value ? current_max_value : value;

                    SV* current_max = newSViv(current_max_value);
                    hv_store(current_metric_values, settings_item, strlen(settings_item), current_max, 0);
                }

                //if (!strcmp (s, "min"))
                {
                    //prin tf("upd: %s!!!\n", s);
                    settings_item = "min";
                    SV* ptr_to_min_value = *(hv_fetch(current_metric_values, settings_item, strlen(settings_item), 0));
                    int current_min_value = SvIV (ptr_to_min_value);

                    //printf("__%s!!!\n", s);

                    current_min_value = value > current_min_value ? current_min_value : value;

                    printf ("cur = %d, val = %d\n", current_min_value, value);

                    SV* current_min = newSViv(current_min_value);
                    hv_store(current_metric_values, settings_item, strlen(settings_item), current_min, 0);
                }

                //if (!strcmp (s, "avg")) {
                //    printf("upd: %s!!\n", s);
                {
                    avg_flag = TRUE;
                }
            //}
            //if (avg_flag)
            /*---CALCULATE AVG---*/
            {
                char *sum = "sum";
                char *cnt = "cnt";
                int _sum;
                int _count;
                //printf ("1\n");
                SV* ptr_to_sum_value = *(hv_fetch(current_metric_values, sum, strlen(sum), 0));
                SV* ptr_to_cnt_value = *(hv_fetch(current_metric_values, cnt, strlen(cnt), 0));
                //printf ("2\n");

                //size_t size_sum_value =
                _sum = SvIV (ptr_to_sum_value);

                //printf ("%d\n", _sum);
                //size_t size_count_value =
                _count = SvIV (ptr_to_cnt_value);
                //printf ("%d\n", _count);
                //_sum = INT2PTR (int, size_sum_value);
                double _avg = _sum / _count;
                SV* avg = newSVnv(_avg);
                hv_store(current_metric_values, "avg", 3, avg, 0);
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
/*
            dSP;
            ENTER;
            SAVETMPS;
            PUSHMARK(SP);
            PUTBACK;
*/
            count = call_sv(x->code, G_ARRAY);
            SPAGAIN;
            //PUTBACK;
            //FREETMPS;
            //LEAVE;

            AV* _settings = newAV();

            for (int j = 0; j < count; j++) {
                //SV *sv_stack = POPs;
                //av_push(tmp_settings, sv_stack);
                av_push(_settings, newSVsv(POPs));
            }

            SV* settings_ref = newRV_inc((SV*) _settings);
            hv_store(metric_values, "_settings", 9, settings_ref, 0);
            //x->settings = tmp_settings;

            printf ("We have %d items in metric settings\n", count);
            //for (int i = 0; i < count; i++) {

                //STRLEN len;
                //printf ("i = %d\n", i);
                //SV *sv = newSVsv(*(av_fetch(x->settings, i, 1)));
                //SV *sv = *(av_fetch(x->settings, i, 1));
                //printf ("i = %d\n", i);
                //char *s = SvPV(sv, len);
                //printf ("%d\n", i);
                //printf("item = %s\n", s);
                //if (!strcmp (s, "sum")) {
                //printf("init: %s!\n", s);
                {
                    settings_item = "sum";
                    SV * sum_value = newSVsv(sv_value);
                    hv_store(metric_values, settings_item, strlen(settings_item), sum_value, 0);
                }
                //}
                //if (!strcmp (s, "cnt")) {
                //printf("init: %s!!\n", s);
                {
                    settings_item = "cnt";
                    hv_store(metric_values, settings_item, strlen(settings_item), unit, 0);
                }
                //}
                //if (!strcmp (s, "min"))
                {
                    //printf("init: %s!!!\n", s);
                    settings_item = "min";
                    SV * min_value = newSVsv(sv_value);
                    hv_store(metric_values, settings_item, strlen(settings_item), min_value, 0);
                }
                //if (!strcmp (s, "max"))
                {
                    //printf("init: %s!!!\n", s);
                    settings_item = "max";
                    SV * max_value = newSVsv(sv_value);
                    hv_store(metric_values, settings_item, strlen(settings_item), max_value, 0);
                }
                //if (!strcmp (s, "avg"))
                {
                    settings_item = "avg";
                    //printf("init: %s!!\n", s);
                    avg_flag = TRUE;
                }
            //}
            //if (avg_flag)
            {
                char *sum = "sum";
                char *cnt = "cnt";
                int _sum;
                int _count;
                //printf ("1\n");
                SV* ptr_to_sum_value = *(hv_fetch(metric_values, sum, strlen(sum), 0));
                SV* ptr_to_cnt_value = *(hv_fetch(metric_values, cnt, strlen(cnt), 0));
                //printf ("2\n");

                //size_t size_sum_value =
                _sum = SvIV (ptr_to_sum_value);

                //printf ("%d\n", _sum);
                //size_t size_count_value =
                _count = SvIV (ptr_to_cnt_value);
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
