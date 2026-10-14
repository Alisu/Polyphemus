tests
testItStepsOverTheBridgeBetweenTwoSegments

	"Old space in two segments, as Windows commits it: the first ends in a bridge (class index 3)
	spanning memory that was never committed, so a dump holds none of it."

	| gap first second space walk |
	gap := 16r1000.
	first := ByteArray streamContents: [ :stream |
		         stream nextPutAll: (self heapBytesFor: self aFewObjects).
		         self putWord: (255 bitShift: 56) + (gap // 8) on: stream.
		         self putWord: (self headerForClass: 3 format: 9 slots: 255) on: stream ].
	second := self heapBytesFor: #( #( 22 1 1 ) #( 23 2 2 ) #( 3 9 0 ) ).
	space := SplitAddressSpace withAll: {
			         (ByteArrayAddressSpace on: first at: self baseAddress).
			         (ByteArrayAddressSpace on: second at: self baseAddress + first size + gap) }.

	walk := (SpurHeapScanner on: space)
		        walkFrom: self baseAddress
		        upTo: self baseAddress + first size + gap + second size.

	"The live end takes in the bridge closing old space: VMMaker plants its own in the last 16
	bytes of the segment it is given, which would otherwise be the last live object."
	self assert: walk lastLiveEnd equals: self baseAddress + first size + gap + second size.
	self assert: walk reachedTheLimit.
	self assert: walk stoppedAt equals: self baseAddress + first size + gap + second size
