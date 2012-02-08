/*
 * Copyright (C) 2010 WIMM Labs, Inc.
 *
 */

#include "wimmtools.h"

#include <fcntl.h>

#include "init.h"

const char* BOOTSEL = "bootsel";

int set_bootsel(int secondary)
{
	int was_secondary = 0;
	const char* value = env_get(BOOTSEL);
	
	was_secondary = (value != NULL) && (strstr(value, "1") != NULL);

	if (secondary != was_secondary)
	{
        NOTICE("toggling boot selector (%i -> %i)\n", was_secondary, secondary);
        
        // We have to call env directly here because persistent properties aren't
        // yet loaded so dev.* properties are not yet getting written to flash.
        // env_init has already been called from property_init, no need to call it
        // here.
	    if (env_set(BOOTSEL, secondary ? "1" : "0") != 0)
	    {
            ERROR("can't set bootsel\n");
            return -1;
        }
        env_write();
	}
	
    return 0;
}

