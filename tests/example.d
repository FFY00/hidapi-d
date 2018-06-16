module example;

import hidapi.device;
import hidapi.devicelist;
import std.stdio;

void main()
{
	// Open the first matching device
	auto dev = new Device(0x1038, 0x1720); // vendor_id, product_id

	// Print info
	writeln("Manufacturer: ", dev.getManufacturer());
	writeln("Product: ", dev.getProduct());
	writeln("Serial Number: ", dev.getSerialNumber());
	writeln("Indexed String #4: ", dev.getIndexedString(4));
	writeln("Indexed String #5: ", dev.getIndexedString(5));
	writeln("Feature Report: ", dev.getFeatureReport(255));

	// Execute a command
	// Sends a buffer to the device and reads the response
	const uint size = 64;
	ubyte[] buf = new ubyte[size];
	buf[0] = 0x90;
	writeln("Command 0x90: ", dev.command(buf, size));

	// Iterates over the device
	foreach(devv; new DeviceList(0x1038, 0x1720))
	{
		writeln("Serial: ", devv.serial_number);
	}
}
