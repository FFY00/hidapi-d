module hidapi.devicelist;

import hidapi.bindings;
import hidapi.hid;
import hidapi.error;

class DeviceList : Hid
{
    ushort vendor_id = 0x0;
    ushort product_id = 0x0;

    /***********************************
     * Sets the search queries
     *
     * Params:
     *      vendor_id =     Vendor ID
     *      product_id =    Product ID
     */
    this(uint vendor_id, uint product_id)
    {
        this.vendor_id = cast(ushort) vendor_id;
        this.product_id = cast(ushort) product_id;
    }

    /***********************************
     * Finds matching devices and iterates over them
     *
     * Example:
     * ---
     * foreach(dev; new DeviceList(0x1038, 0x1720))
     * {
	 *	writeln("Serial: ", dev.serial_number);
	 * }
     * ---
     */
    int opApply(scope int delegate(ref hid_device_info) dg)
    {
        hid_device_info* devs = null;
        devs = hid_enumerate(vendor_id, this.product_id);
        
        int result;
        while(devs)
        {
            result = dg(*devs);
            devs = (*devs).next;
            if(result)
                break;
        }

        hid_free_enumeration(devs);

        return result;
    }
}
