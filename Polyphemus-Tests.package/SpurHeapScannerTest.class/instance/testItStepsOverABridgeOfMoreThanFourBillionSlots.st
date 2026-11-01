tests
testItStepsOverABridgeOfMoreThanFourBillionSlots

	"VM 9 puts a segment old space adds about 127 TB away: the bridge's overflow word counts its
	slots on 56 bits. Read on 32, the walk stepped into the gap (#144)."

	| gap first second space |
	gap := 1 bitShift: 40.
	first := ByteArray streamContents: [ :stream |
		         stream nextPutAll: (self heapBytesFor: self aFewObjects).
		         self putWord: (255 bitShift: 56) + (gap // 8) on: stream.
		         self putWord: (self headerForClass: 3 format: 9 slots: 255) on: stream ].
	second := self heapBytesFor: #( #( 22 1 1 ) #( 23 2 2 ) #( 3 9 0 ) ).
	space := SplitAddressSpace withAll: {
			         (ByteArrayAddressSpace on: first at: self baseAddress).
			         (ByteArrayAddressSpace on: second at: self baseAddress + first size + gap) }.

	self
		assert: ((SpurHeapScanner on: space) objectAfter: self baseAddress + first size - 8)
		equals: self baseAddress + first size + gap
