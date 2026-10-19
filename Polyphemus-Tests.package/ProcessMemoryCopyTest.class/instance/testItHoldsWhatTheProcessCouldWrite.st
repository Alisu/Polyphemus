tests
testItHoldsWhatTheProcessCouldWrite

	| copy |
	copy := ProcessMemoryCopy of: process.
	process forget.
	self assert: (copy bytesAt: 16r10000 count: 4096) equals: (ByteArray new: 4096 withAll: 1)
