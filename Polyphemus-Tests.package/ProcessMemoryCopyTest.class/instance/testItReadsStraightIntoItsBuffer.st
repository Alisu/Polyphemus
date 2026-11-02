tests
testItReadsStraightIntoItsBuffer

	"The copy reads each block into its own buffer, not into a ByteArray of its own copied over:
	about 500 ms of a step's 900 on a Mac went to the copy (#135)."

	| regions copy |
	regions := RegionsDouble new
		           region: 16r10000 bytes: (ByteArray new: 4096 withAll: 1) writable: true;
		           yourself.
	copy := ProcessMemoryCopy of: regions.
	self assert: (copy bytesAt: 16r10FFF count: 1) asArray equals: #( 1 ).
	self assert: regions bytesAsked equals: 0
