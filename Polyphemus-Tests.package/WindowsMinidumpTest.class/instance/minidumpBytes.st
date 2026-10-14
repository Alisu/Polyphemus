building the dump
minidumpBytes

	^ self minidumpOf: {
			  (16r10000000000 -> (ByteArray new: 16r100 withAll: 16rAA)).
			  (16r360000000 -> (ByteArray new: 16r80 withAll: 16rBB)) }
