running
setUp

	super setUp.
	memory := ProcessMemoryOfBytes on: (ByteArray new: 64) at: 16r1000.
	memory run
