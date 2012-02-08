/*
 * Copyright (C) 2011 WIMM Labs, Inc.
 *
 */

#include "wimmtools.h"

#include "log.h"
#include "property_service.h"

#include <sys/reboot.h>

const char* VERIFY_FAIL = "ro.verifyfail";

extern int toggle_bootsel();

int verify_system()
{
    NOTICE("verifying system...\n");

    int ret = verify_partition("system", 0);

    if (ret == 0)
    {
        NOTICE("verify system succeeded!\n");
    }
    else
    {
        ERROR("verify system failed! (%i)\n", ret);

        property_set(VERIFY_FAIL, "1");        
        toggle_bootsel();
        reboot(RB_AUTOBOOT);
    }

    return ret; 
}

