#include "wimmtools.h"

#include "init.h"

int get_devkey(char* devkey, size_t* devkey_len)
{
    const char* value = property_get("dev.devkey");
	
	devkey[0] = 0;
	
    if (value == NULL)
        return -1;

    size_t value_len = strlen(value);

    if (devkey_len <= value_len)
    {
        *devkey_len = value_len+1;
        return -1;
    }
    
    strcpy(devkey, value);

    *devkey_len = strlen(devkey);
    
    return 0;
}

