module hidapi.hid;

import hidapi.bindings;
import hidapi.error;
import std.exception : enforce;

class Hid
{

    /**
     * Inits the HIDAPI 
     */
    shared static this()
    {
        int ret = hid_init();
        enforce!HidError(ret != -1, "Failed to init HIDAPI");
    }

    /**
     * Exits the HIDAPI
     *
     * This is generating an error so
     * it's disabled at the moment.
     */
    shared static ~this()
    {
        int ret = hid_exit();
        enforce!HidError(ret != -1, "Failed to exit HIDAPI");
    }

}
