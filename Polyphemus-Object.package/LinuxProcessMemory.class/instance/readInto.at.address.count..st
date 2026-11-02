reading
readInto: aBuffer at: anIndex address: anAddress count: aCount

	"As bytesAt:count:, /proc/<pid>/mem read straight into aBuffer: no ByteArray of its own, no
	second copy (#135)."

	(self hasAddress: anAddress) ifFalse: [ ^ false ].
	^ ([
	   self stream position: 0.
	   self stream position: anAddress.
	   self stream readInto: aBuffer startingAt: anIndex count: aCount ] on: Error do: [ :e | 0 ]) = aCount
