running
setUp

	"Three regions: one written to, one the VM library maps read-only, one read-only that is
	neither. The last is what the copy leaves out."

	super setUp.
	process := RegionsDouble new
		           region: 16r10000 bytes: (ByteArray new: 4096 withAll: 1) writable: true;
		           region: 16r20000 bytes: (ByteArray new: 4096 withAll: 2) writable: false;
		           region: 16r30000 bytes: (ByteArray new: 4096 withAll: 3) writable: false;
		           mapFile: '/opt/pharo/lib/libPharoVMCore.so' from: 16r20000 to: 16r21000;
		           yourself
