module example;import hidapi.bindings;
import hidapi.device;
import std.stdio;

void main()
{
	auto dev = new Device(0x1038, 0x1720);

	writeln("Manufacturer: ", dev.getManufacturer());
	writeln("Product: ", dev.getProduct());
	writeln("Serial Number: ", dev.getSerialNumber());
	writeln("Feature Report: ", dev.getFeatureReport(255));
	writeln("Indexed String #4:", dev.getIndexedString(4));
	writeln("Indexed String #5:", dev.getIndexedString(5));

	const uint size = 64;
	ubyte[] buf = new ubyte[size];
	buf[0] = 0x90;
	writeln("", dev.command(buf, size));

	Device.find(0x1038, 0x1720,
		function (hid_device_info* devv, uint n)
		{
			writefln("Serial #%d: %s", n, (*devv).serial_number);
		}
	);

	// Allows to pass a bool: callback(device, uint, bool)
	Device.find(0x1038, 0x1720,
		function (hid_device_info* devv, uint n, ref bool stop)
		{
			if(stop)
				return;
			
			writefln("Serial #%d: %s", n, (*devv).serial_number);
			if(n >= 2)
				stop = true;
		}
	);

}
