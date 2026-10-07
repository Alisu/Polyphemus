naming
stringOf: aBytesOop

	^ String
		  new: (objectMemory numBytesOf: aBytesOop)
		  streamContents: [ :stream |
			  0 to: (objectMemory numBytesOf: aBytesOop) - 1 do: [ :i |
				  stream nextPut: (Character value: (objectMemory fetchByte: i ofObject: aBytesOop)) ] ]
