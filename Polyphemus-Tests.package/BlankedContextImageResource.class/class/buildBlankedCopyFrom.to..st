building the fixture
buildBlankedCopyFrom: aCleanImage to: aTarget

	"Copy aCleanImage with the running process's suspendedContext zeroed in the file bytes.
	The file offset comes from the header and is checked on six objects first."

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
