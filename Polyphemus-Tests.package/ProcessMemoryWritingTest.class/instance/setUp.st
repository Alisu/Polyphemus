running
setUp

	super setUp.
	process := ProcessMemoryOfBytes on: (ByteArray new: 4096) at: 16r10000
