reading
bytesAt: anAddress count: aCount

	"The offsets of /proc/<pid>/mem are addresses, and a read answers all the bytes or nil
	(#15). Sought away from first: below the stream, a seek inside what was last read answers
	those bytes again, and a live process changes under us (#26)."

	| buffer read |
	(self hasAddress: anAddress) ifFalse: [ ^ nil ].
	buffer := ByteArray new: aCount.
	read := [
	        self stream position: 0.
	        self stream position: anAddress.
	        self stream readInto: buffer startingAt: 1 count: aCount ] on: Error do: [ :e | 0 ].
	^ read = aCount ifTrue: [ buffer ] ifFalse: [ nil ]
