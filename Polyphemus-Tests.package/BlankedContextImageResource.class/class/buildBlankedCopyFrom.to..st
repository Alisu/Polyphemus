building the fixture
buildBlankedCopyFrom: aCleanImage to: aTarget

	"Blank the slot where the running process keeps its stack: eight bytes of zero,
	written straight into the file, where a pointer to a context used to be.

	Finding that slot means knowing where in the file an object of the loaded image
	lives. The simulator loads the heap at an address of its own, so the shift between
	the two is worked out from the one object whose place in the file is written in the
	header, the special objects array, and then checked against six more before a byte
	is written. A fixture built on arithmetic nobody verified is worse than no fixture."

	| reader memory process slotAddress header delta offsetOf |
	reader := AbstractInspectorsTest new.
	reader imagePath: aCleanImage fullName.
	reader setUpForResourceMarrying: false.
	memory := reader instVarNamed: 'reifiedMemory'.

	header := self headerOf: aCleanImage.
	delta := memory reifiedSpecialObjectArray address
	         - (header at: #specialObjectsOop).
	offsetOf := [ :simAddress |
	            (header at: #headerSize) + simAddress - delta
	            - (header at: #oldBaseAddress) ].

	self
		verifyMapping: offsetOf
		of: memory
		in: aCleanImage.

	process := memory reifiedActiveProcess.
	slotAddress := process address + 8
	               + ((memory processSuspendedContextSlot - 1) * 8).

	aCleanImage copyTo: aTarget.
	[
	| stream |
	stream := [ aTarget binaryReadWriteStream ]
		          on: Error
		          do: [ :e | (File named: aTarget fullName) writeStream ].
	stream position: (offsetOf value: slotAddress).
	stream nextPutAll: (ByteArray new: 8 withAll: 0).
	stream
		flush;
		close ] value.

	^ aTarget
