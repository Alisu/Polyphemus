tests
testTouchingRegionsAreHeldAsOnePiece

	"macOS lists a heap as many touching regions: held as one piece, the raw heap reads it in place
	instead of copying it a second time (#122)."

	| regions copy |
	regions := RegionsDouble new
		           region: 16r10000 bytes: (ByteArray new: 4096 withAll: 1) writable: true;
		           region: 16r11000 bytes: (ByteArray new: 4096 withAll: 2) writable: true;
		           yourself.
	copy := ProcessMemoryCopy of: regions.
	self assert: (copy pieceFrom: 16r10000 upTo: 16r12000) notNil.
	self assert: (copy bytesAt: 16r10FFF count: 2) asArray equals: #( 1 2 )
