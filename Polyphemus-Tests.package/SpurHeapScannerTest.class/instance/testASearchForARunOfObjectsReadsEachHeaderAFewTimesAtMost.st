tests
testASearchForARunOfObjectsReadsEachHeaderAFewTimesAtMost

	"#182: the search walked again from every candidate, each walk to its end: a stretch of free
	chunks it does not count was walked from each of its chunks. A few reads per word at most."

	| specs space bytes found |
	specs := ((1 to: 400) collect: [ :each | #( 0 0 1 ) ]) , ((1 to: 40) collect: [ :each | #( 17 1 1 ) ]).
	bytes := (self heapBytesFor: specs) size.
	space := CountingAddressSpace on: (self spaceFor: specs).

	found := (SpurHeapScanner on: space)
		         firstObjectRunFrom: self baseAddress
		         upTo: self baseAddress + bytes
		         atLeast: 50.

	self assert: found isNil.
	self assert: space reads <= (bytes / 8 * 10)