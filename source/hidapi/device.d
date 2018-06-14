module hidapi.device;

import hidapi.bindings;
import hidapi.error;
import std.exception : enforce;
import std.format : format;

class Device {
    private hid_device* handle = null;
    private uint timeout = 5;
    private uint default_read_size = 64;
    private int ret = 0;

    shared static this()
    {
        int ret = hid_init();
        enforce!HidError(ret != -1, "Failed to init HIDAPI");
    }

    shared static ~this()
    {
        //int ret = hid_exit();
        int ret = 0;
        enforce!HidError(ret != -1, "Failed to exit HIDAPI");
    }

    static find(uint vendor_id, uint product_id, void function(hid_device_info*) callback)
    {
        auto devs = hid_enumerate(cast(ushort) vendor_id, cast(ushort) product_id);
        while(devs)
        {
            callback(devs);
            devs = (*devs).next;
        }
    }

    static find(uint vendor_id, uint product_id, void function(hid_device_info*, uint) callback)
    {
        auto devs = hid_enumerate(cast(ushort) vendor_id, cast(ushort) product_id);
        uint n = 0;
        while(devs)
        {
            callback(devs, ++n);
            devs = (*devs).next;
        }
    }

    static find(uint vendor_id, uint product_id, void function(hid_device_info*, uint, ref bool) callback)
    {
        auto devs = hid_enumerate(cast(ushort) vendor_id, cast(ushort) product_id);
        uint n = 0;
        bool b = false;
        while(devs)
        {
            callback(devs, ++n, b);
            devs = (*devs).next;
        }
    }

    this(uint vendor_id, uint product_id)
    {
        handle = hid_open(cast(ushort) vendor_id, cast(ushort) product_id, null);
        enforce!HidError(handle != null, "Failed to open the device");
    }

    this(uint vendor_id, uint product_id, string serial_number)
    {
        handle = hid_open(cast(ushort) vendor_id, cast(ushort) product_id, cast(immutable(dchar)*) serial_number.ptr);
        enforce!HidError(handle != null, "Failed to open the device");
    }

    this(string path)
    {
        handle = hid_open_path(cast(immutable(char)*) path.ptr);
        enforce!HidError(handle != null, "Failed to open the device");
    }

    void write(ubyte[] buf, uint size)
    {
        hid_write(handle, buf.ptr, size);
    }

    ubyte[] read()
    {
        return read(default_read_size);
    }

    ubyte[] read(uint size)
    {
        ubyte[] buf = new ubyte[default_read_size];
        ret = hid_read_timeout(handle, buf.ptr, size, timeout);
        enforce!HidError(ret != -1, "Error reading from the device");
        return buf;
    }

    ubyte[] command(ubyte[] buf, uint size)
    {
        write(buf, size);
        return read();
    }

    ubyte[] command(ubyte[] buf, uint size, uint read_size)
    {
        write(buf, size);
        return read(read_size);
    }

    void setNonBlockingMode(bool mode)
    {
        hid_set_nonblocking(handle, mode ? 1 : 0);
        enforce!HidError(ret != -1, "Error setting non-blocking mode");
    }

    void sendFeatureReport(ubyte[] buf, uint size)
    {
        ret = hid_send_feature_report(handle, buf.ptr, size);
        enforce!HidError(ret != -1, "Error sending feature report");
    }

    ubyte[] getFeatureReport(uint size)
    {
        ubyte[] buf = new ubyte[size];
        ret = hid_get_feature_report(handle, buf.ptr, size);
        enforce!HidError(ret != -1, "Error getting feature report");
        return buf;
    }

    string getManufacturer()
    {
        return getManufacturer(255);
    }

    string getManufacturer(uint size)
    {
        dchar[] buf = new dchar[size];
        ret = hid_get_manufacturer_string(handle, buf.ptr, size);
        enforce!HidError(ret != -1, "Error getting the manufacturer");
        return cast(string) buf;
    }

    string getProduct()
    {
        return getProduct(255);
    }

    string getProduct(uint size)
    {
        dchar[] buf = new dchar[size];
        ret = hid_get_product_string(handle, buf.ptr, size);
        enforce!HidError(ret != -1, "Error getting the product");
        return cast(string) buf;
    }

    string getSerialNumber()
    {
        return getSerialNumber(255);
    }

    string getSerialNumber(uint size)
    {
        dchar[] buf = new dchar[size];
        ret = hid_get_serial_number_string(handle, buf.ptr, size);
        enforce!HidError(ret != -1, "Error getting the serial number");
        return cast(string) buf;
    }

    string getIndexedString(uint index)
    {
        return getIndexedString(index, 255);
    }

    string getIndexedString(uint index, uint size)
    {
        dchar[] buf = new dchar[size];
        ret = hid_get_indexed_string(handle, index, buf.ptr, size);
        enforce!HidError(ret != -1,
                            format("Error getting the indexed string #%d", index));
        return cast(string) buf;
    }

    uint getTimeout()
    {
        return timeout;
    }

    void setTimeout(uint timeout)
    {
        this.timeout = timeout;
    }

    uint getDefaultReadSize()
    {
        return default_read_size;
    }

    void setDefaultReadSize(uint size)
    {
        default_read_size = size;
    }

}