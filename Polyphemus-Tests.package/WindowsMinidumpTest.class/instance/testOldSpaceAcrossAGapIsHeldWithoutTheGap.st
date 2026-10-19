tests
testOldSpaceAcrossAGapIsHeldWithoutTheGap

	"The memory between two segments was never committed: the heap holds a copy of each, not of
	the gap. Held as one ByteArray, the gap cost as much as the heap once the host had grown (#86)."

	| scanner gap first second file heap |
	scanner := SpurHeapScannerTest new.
	gap := 16r100000.
	first := ByteArray streamContents: [ :stream |
		         stream nextPutAll: (scanner heapBytesFor: scanner aFewObjects , { #( 30 2 2000 ) }).
		         scanner putWord: (255 bitShift: 56) + (gap // 8) on: stream.
		         scanner putWord: (scanner headerForClass: 3 format: 9 slots: 255) on: stream ].
	second := scanner heapBytesFor: #( #( 22 1 1 ) #( 23 2 2 ) ).
	file := PolyphemusEdition current scratch / 'polyphemus-two-segments-held.dmp'.
	file ensureDelete.
	file binaryWriteStreamDo: [ :stream |
		stream nextPutAll: (self minidumpOf: {
					 (16r10000000000 -> first).
					 (16r10000000000 + first size + gap -> second) }) ].
	[
	heap := SpurRawHeap on: (FileAddressSpace onDump: file).
	self assert: heap heldByteCount equals: first size + second size.
	self assert: heap mappingLimit equals: 16r10000000000 + first size + gap + second size.
	self assert: (heap space unsignedAt: 16r10000000000 + first size + gap size: 8) notNil.
	self
		assert: (heap scanner headerAt: 16r10000000000 + first size + gap)
		equals: (heap space unsignedAt: 16r10000000000 + first size + gap size: 8) ] ensure: [
		heap ifNotNil: [ heap space close ].
		file ensureDelete ]
