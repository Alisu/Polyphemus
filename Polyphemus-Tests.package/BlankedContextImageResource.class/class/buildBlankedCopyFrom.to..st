building the fixture
buildBlankedCopyFrom: aCleanImage to: aTarget

	"Copy aCleanImage with the running process's suspendedContext zeroed in the file's bytes, at
	an offset checked on six objects first; built under a name of its own and renamed onto
	aTarget, so a class reading or building it at the same time finds it whole and blanked."

	| reader memory process slotAddress header delta offsetOf building |
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

	building := aTarget parent / ('.' , aTarget basename , '.' , UUID new asString , '.building').
	aCleanImage copyTo: building.
	[
	| stream |
	stream := [ building binaryReadWriteStream ]
		          on: Error
		          do: [ :e | (File named: building fullName) writeStream ].
	stream position: (offsetOf value: slotAddress).
	stream nextPutAll: (ByteArray new: 8 withAll: 0).
	stream
		flush;
		close ] value.
	LibC runCommand: 'mv -f ' , building fullName , ' ' , aTarget fullName.

	^ aTarget
