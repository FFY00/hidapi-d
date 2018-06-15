module hidapi.device;

import hidapi.bindings;
import hidapi.error;
import hidapi.hid;
import std.exception : enforce;
import std.format : format;

class Device : Hid
{
    private hid_device* handle = null;
    private uint timeout = 5;
    private uint default_read_size = 64;
    private int ret = 0;

    /**
     * Opens the first matching device
     *
     * Params:
     *      vendor_id =     Vendor ID
     *      product_id =    Product ID
     */
    this(uint vendor_id, uint product_id)
    {
        handle = hid_open(cast(ushort) vendor_id, cast(ushort) product_id, null);
        enforce!HidError(handle != null, "Failed to open the device");
    }

    /**
     * Opens the first matching device 
     *
     * Params:
     *      vendor_id =     Vendor ID
     *      product_id =    Product ID
     *      serial_nuber =  Serial Number
     */
    this(uint vendor_id, uint product_id, string serial_number)
    {
        handle = hid_open(cast(ushort) vendor_id, cast(ushort) product_id, cast(immutable(dchar)*) serial_number.ptr);
        enforce!HidError(handle != null, "Failed to open the device");
    }

    /**
     * Opens a specific device
     *
     * Params:
     *      path =  Device path
     */
    this(string path)
    {
        handle = hid_open_path(cast(immutable(char)*) path.ptr);
        enforce!HidError(handle != null, "Failed to open the device");
    }

    /**
     * Writes to the device 
     *
     * Params:
     *      buf =   Buffer
     *      size =  Buffer size
     */
    void write(ubyte[] buf, uint size)
    {
        hid_write(handle, buf.ptr, size);
    }

    /**
     * Reads from the device
     *
     * Returns: Buffer
     */
    ubyte[] read()
    {
        return read(default_read_size);
    }

    /**
     * Reads from the device
     *
     * Params:
     *      size =  Size to read
     *
     * Returns: Buffer
     */
    ubyte[] read(uint size)
    {
        ubyte[] buf = new ubyte[default_read_size];
        ret = hid_read_timeout(handle, buf.ptr, size, timeout);
        enforce!HidError(ret != -1, "Error reading from the device");
        return buf;
    }

    /**
     * Executes a command
     *
     * Sends a buffer to the device
     * and reurns the reply.
     *
     * Params:
     *      buf =   Buffer
     *      size =  Buffer size
     *
     * Returns: Reply buffer
     */
    ubyte[] command(ubyte[] buf, uint size)
    {
        write(buf, size);
        return read();
    }

    /**
     * Executes a command
     *
     * Sends a buffer to the device
     * and reurns the reply.
     *
     * Params:
     *      buf =   Buffer
     *      size =  Buffer size
     *      read_size = Size to read
     *
     * Returns: Reply buffer
     */
    ubyte[] command(ubyte[] buf, uint size, uint read_size)
    {
        write(buf, size);
        return read(read_size);
    }

    /**
     * Enables/Disables non-blocking mode
     *
     * Params:
     *      buf =   Buffer
     */
    void setNonBlockingMode(bool mode)
    {
        hid_set_nonblocking(handle, mode ? 1 : 0);
        enforce!HidError(ret != -1, "Error setting non-blocking mode");
    }

    /**
     * Sends a feature report
     *
     * Params:
     *      buf =   Buffer
     *      size =  Buffer size
     */
    void sendFeatureReport(ubyte[] buf, uint size)
    {
        ret = hid_send_feature_report(handle, buf.ptr, size);
        enforce!HidError(ret != -1, "Error sending feature report");
    }

    /**
     * Reads a feature report
     *
     * Params:
     *      size =  Size to read
     *
     * Returns: Buffer
     */
    ubyte[] getFeatureReport(uint size)
    {
        ubyte[] buf = new ubyte[size];
        ret = hid_get_feature_report(handle, buf.ptr, size);
        enforce!HidError(ret != -1, "Error getting feature report");
        return buf;
    }

    /**
     * Reads the manufacturer string
     *
     * Returns: Manufacturer string
     */
    string getManufacturer()
    {
        return getManufacturer(255);
    }

    /**
     * Reads the manufacturer string
     *
     * Params:
     *      size =  Size to read
     *
     * Returns: Manufacturer string
     */
    string getManufacturer(uint size)
    {
        dchar[] buf = new dchar[size];
        ret = hid_get_manufacturer_string(handle, buf.ptr, size);
        enforce!HidError(ret != -1, "Error getting the manufacturer");
        return cast(string) buf;
    }

    /**
     * Reads the product string
     *
     * Returns: Product string
     */
    string getProduct()
    {
        return getProduct(255);
    }

    /**
     * Reads the product string
     *
     * Params:
     *      size =  Size to read
     *
     * Returns: Product string
     */
    string getProduct(uint size)
    {
        dchar[] buf = new dchar[size];
        ret = hid_get_product_string(handle, buf.ptr, size);
        enforce!HidError(ret != -1, "Error getting the product");
        return cast(string) buf;
    }

    /**
     * Reads the serial number
     *
     * Returns: Serial number
     */
    string getSerialNumber()
    {
        return getSerialNumber(255);
    }

    /**
     * Reads the serial number
     *
     * Params:
     *      size =  Size to read
     *
     * Returns: Serial number
     */
    string getSerialNumber(uint size)
    {
        dchar[] buf = new dchar[size];
        ret = hid_get_serial_number_string(handle, buf.ptr, size);
        enforce!HidError(ret != -1, "Error getting the serial number");
        return cast(string) buf;
    }

    /**
     * Reads a indexed string
     *
     * Params:
     *      index = String index
     *
     * Returns: Indexed string
     */
    string getIndexedString(uint index)
    {
        return getIndexedString(index, 255);
    }

    /**
     * Reads a indexed string
     *
     * Params:
     *      index = String index
     *      size =  Size to read
     *
     * Returns: Indexed string
     */
    string getIndexedString(uint index, uint size)
    {
        dchar[] buf = new dchar[size];
        ret = hid_get_indexed_string(handle, index, buf.ptr, size);
        enforce!HidError(ret != -1,
                            format("Error getting the indexed string #%d", index));
        return cast(string) buf;
    }

    /**
     * Gets the timeout
     *
     * Returns: Timeout
     */
    uint getTimeout()
    {
        return timeout;
    }

    /**
     * Sets the timeout 
     *
     * Params:
     *      timeout =   Timeout
     */
    void setTimeout(uint timeout)
    {
        this.timeout = timeout;
    }

    /**
     * Gets the default read size
     *
     * Returns: Read size
     */
    uint getDefaultReadSize()
    {
        return default_read_size;
    }

    /**
     * Sets the deafult read size
     *
     * Params:
     *      size =  Read size
     */
    void setDefaultReadSize(uint size)
    {
        default_read_size = size;
    }

}
