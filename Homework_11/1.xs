CV* new(code)
        CV* code;
    PPCODE:
        int count;

        ENTER;
        SAVETMPS;

        PUSHMARK(SP);
        XPUSHs(sv_2mortal(newSViv(9)));

        count = call_pv("Local::Stats::x", G_ARRAY|G_NOARGS);

char* add(name, value)
        char* name;
        HV* value;
    CODE:
        RETVAL = name;
    OUTPUT:
        RETVAL
