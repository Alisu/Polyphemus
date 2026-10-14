tests
testOldSpaceGoesOnPastTheGapItsBridgeSpans

	"Windows commits old space a segment at a time, with memory never committed between them:
	the heap is every segment its bridges lead to, not only the mappings that touch."

	| scanner gap first second file heap |
	scanner := SpurHeapScannerTest new.
	gap := 16r100000.
	first := ByteArray streamContents: [ :stream |
		         stream nextPutAll: (scanner heapBytesFor: scanner aFewObjects , { #( 30 2 2000 ) }).
		         scanner putWord: (255 bitShift: 56) + (gap // 8) on: stream.
		         scanner putWord: (scanner headerForClass: 3 format: 9 slots: 255) on: stream ].
	second := scanner heapBytesFor: #( #( 22 1 1 ) #( 23 2 2 ) ).
	file := PolyphemusEdition current scratch / 'polyphemus-two-segments.dmp'.
	file ensureDelete.
	file binaryWriteStreamDo: [ :stream |
		stream nextPutAll: (self minidumpOf: {
					 (16r10000000000 -> first).
					 (16r10000000000 + first size + gap -> second) }) ].
	[
	heap := SpurRawHeap on: (FileAddressSpace onDump: file).
	self assert: heap mappingStart equals: 16r10000000000.
	self assert: heap mappingLimit equals: 16r10000000000 + first size + gap + second size ]
		ensure: [
			heap ifNotNil: [ heap space close ].
			file ensureDelete ]
