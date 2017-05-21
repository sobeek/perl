#include "EXTERN.h"
#include "perl.h"
#include "XSUB.h"

#include "ppport.h"

typedef struct {
    SV* code;
    HV* metrics;
} METRIC;

/* TO GET THE STRUCTURE FIELDS:
        METRIC* x;
        SV * sv_obj = SvRV(obj);
        size_t z = SvIV (sv_obj);
        x = INT2PTR(METRIC*, z);
*/

MODULE = Stats		PACKAGE = Stats

SV* new(code)
        SV* code;
    CODE:
        METRIC * self = malloc( sizeof(METRIC) );
        self->code = code;
        self->metrics = newHV();
        // Convert pointer to size_t
        size_t point_iv = PTR2IV(self);
        // Convert size_t to SV*
        SV* sv = newSViv(point_iv);
        // Create reference to SV*
        SV* svrv = newRV_inc(sv);
        // Create Object
        SV* obj_self = sv_bless(svrv, gv_stashpv(SvPV_nolen(ST(0)), 1));
        RETVAL = obj_self;
    OUTPUT:
        RETVAL

HV* stat(self)
        SV* self
    CODE:
        METRIC* calculated_metrics;
        SV * calculated_metrics_sv = SvRV(self);
        size_t size_calculated_metrics = SvIV (calculated_metrics_sv);
        calculated_metrics = INT2PTR(METRIC*, size_calculated_metrics);

        char * key;
        char * _settings = "_settings";
        HV* hash_to_output = newHV();

        I32 hash_keys_number = hv_iterinit(calculated_metrics->metrics);
        for (int i = 1; i < hash_keys_number; i++) {
            HE* self_metrics_hash_entry = hv_iternext(calculated_metrics->metrics);
            key = hv_iterkey(self_metrics_hash_entry, &hash_keys_number);

            SV* ptr_to_current_metric_values = *hv_fetch(calculated_metrics->metrics, key, strlen(key), 0);
            size_t size_current_metric_values = SvIV (ptr_to_current_metric_values);
            HV* current_metric_values = INT2PTR (HV*, size_current_metric_values);

            SV* sv_settings = *hv_fetch(current_metric_values, _settings, strlen(_settings), 0);
            size_t size_settings = SvIV(sv_settings);
            AV* settings = INT2PTR(AV*, size_settings);
            int len_settings = av_len(settings) + 1;

            if (0 == len_settings) {
                hv_delete(calculated_metrics->metrics, key, strlen(key), 0);
                continue;
            }
            else {
                HV* output_metric_values = newHV();
                STRLEN len;
                for (int j = 0; j < len_settings; j++) {
                    SV* sv_output_item = *av_fetch(settings, j, 0);
                    char *output_item = SvPV(sv_output_item, len);

                    SV * output_item_value = *hv_fetch(current_metric_values, output_item, strlen(output_item), 0);
                    hv_store(output_metric_values, output_item, strlen(output_item), output_item_value, 0);
                }
                hv_store(hash_to_output, key, strlen(key), newRV_inc((SV*) output_metric_values), 0);
            }
        }
        hv_undef(calculated_metrics->metrics);
        calculated_metrics->code = (SV*) NULL;
        RETVAL = hash_to_output;
    OUTPUT:
        RETVAL

HV* add(_self, name, sv_value)
        SV* _self;
        char* name;
        SV* sv_value;
    CODE:
        int count;
        char * settings_item;
        METRIC* self;
        SV * ptr_to_self = SvRV(_self);
        size_t self_size = SvIV (ptr_to_self);
        self = INT2PTR(METRIC*, self_size);

        if (hv_exists(self->metrics, name, strlen(name))) {

            SV* ptr_to_current_metric_values = *hv_fetch(self->metrics, name, strlen(name), 0);
            size_t size_current_metric_values = SvIV (ptr_to_current_metric_values);
            HV* current_metric_values = INT2PTR (HV*, size_current_metric_values);

            RETVAL = self->metrics;

            int value = SvIV (sv_value);

            /*---SUM---*/

            {
                settings_item = "sum";
                SV* ptr_to_sum_value = *(hv_fetch(current_metric_values, settings_item, strlen(settings_item), 0));
                int current_sum_value = SvIV (ptr_to_sum_value);

                current_sum_value += value;

                SV* current_sum = newSViv(current_sum_value);

                hv_store(current_metric_values, settings_item, strlen(settings_item), current_sum, 0);
            }
                /*---CNT---*/
            {
                settings_item = "cnt";
                SV* ptr_to_cnt_value = *(hv_fetch(current_metric_values, settings_item, strlen(settings_item), 0));
                int current_cnt_value = SvIV (ptr_to_cnt_value);

                current_cnt_value++;

                SV* current_cnt = newSViv(current_cnt_value);

                hv_store(current_metric_values, settings_item, strlen(settings_item), current_cnt, 0);
            }

            {
                settings_item = "max";
                SV* ptr_to_max_value = *(hv_fetch(current_metric_values, settings_item, strlen(settings_item), 0));
                int current_max_value = SvIV (ptr_to_max_value);

                current_max_value = current_max_value > value ? current_max_value : value;

                SV* current_max = newSViv(current_max_value);
                hv_store(current_metric_values, settings_item, strlen(settings_item), current_max, 0);
            }

            {
                settings_item = "min";
                SV* ptr_to_min_value = *(hv_fetch(current_metric_values, settings_item, strlen(settings_item), 0));
                int current_min_value = SvIV (ptr_to_min_value);

                current_min_value = value > current_min_value ? current_min_value : value;

                SV* current_min = newSViv(current_min_value);
                hv_store(current_metric_values, settings_item, strlen(settings_item), current_min, 0);
            }

            /*---CALCULATE AVG---*/
            {
                char *sum = "sum";
                char *cnt = "cnt";
                int _sum;
                int _count;

                SV* ptr_to_sum_value = *(hv_fetch(current_metric_values, sum, strlen(sum), 0));
                SV* ptr_to_cnt_value = *(hv_fetch(current_metric_values, cnt, strlen(cnt), 0));

                _sum = SvIV (ptr_to_sum_value);
                _count = SvIV (ptr_to_cnt_value);

                double _avg = _sum / _count;
                SV* avg = newSVnv(_avg);
                hv_store(current_metric_values, "avg", 3, avg, 0);
            }
        }

        else {
            HV* metric_values = newHV();
            SV* unit = newSViv(1);
            count = call_sv(self->code, G_ARRAY);
            SPAGAIN;

            AV* _settings = newAV();

            for (int j = 0; j < count; j++) {
                av_push(_settings, newSVsv(POPs));
            }

            SV* settings_ref = newRV_inc((SV*) _settings);
            hv_store(metric_values, "_settings", 9, settings_ref, 0);

            {
                settings_item = "sum";
                SV * sum_value = newSVsv(sv_value);
                hv_store(metric_values, settings_item, strlen(settings_item), sum_value, 0);
            }

            {
                settings_item = "cnt";
                hv_store(metric_values, settings_item, strlen(settings_item), unit, 0);
            }

            {
                settings_item = "min";
                SV * min_value = newSVsv(sv_value);
                hv_store(metric_values, settings_item, strlen(settings_item), min_value, 0);
            }

            {
                settings_item = "max";
                SV * max_value = newSVsv(sv_value);
                hv_store(metric_values, settings_item, strlen(settings_item), max_value, 0);
            }

            {
                char *sum = "sum";
                char *cnt = "cnt";
                int _sum;
                int _count;

                SV* ptr_to_sum_value = *(hv_fetch(metric_values, sum, strlen(sum), 0));
                SV* ptr_to_cnt_value = *(hv_fetch(metric_values, cnt, strlen(cnt), 0));

                _sum = SvIV (ptr_to_sum_value);
                _count = SvIV (ptr_to_cnt_value);

                double _avg = _sum / _count;
                SV* avg = newSVnv(_avg);
                hv_store(metric_values, "avg", 3, avg, 0);
            }

            hv_store(self->metrics, name, strlen(name), newRV_inc((SV*) metric_values), 0);
            RETVAL = self->metrics;
        }
    OUTPUT:
        RETVAL
