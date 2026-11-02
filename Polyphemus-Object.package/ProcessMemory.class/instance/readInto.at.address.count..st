reading
readInto: aBuffer at: anIndex address: anAddress count: aCount

	"aCount bytes from anAddress into aBuffer from anIndex; whether they all were. A reader that
	can read straight into it says so (#135)."

	^ (self bytesAt: anAddress count: aCount)
		  ifNil: [ false ]
		  ifNotNil: [ :bytes |
			  aBuffer replaceFrom: anIndex to: anIndex + aCount - 1 with: bytes startingAt: 1.
			  true ]
