tests
testOldSpaceInTouchingRegionsIsHeldWhole

	"Two regions, one right after the other, as a core of Pharo 10 has them: held as one piece,
	both copied. Taking the first's end for where the memory stopped lost the second."

	| scanner first second file heap |
	scanner := SpurHeapScannerTest new.
	first := scanner heapBytesFor: scanner aFewObjects , { #( 30 2 2000 ) }.
	second := scanner heapBytesFor: #( #( 22 1 1 ) #( 23 2 2 ) ).
	file := PolyphemusEdition current scratch / 'polyphemus-two-touching.dmp'.
	file ensureDelete.
	file binaryWriteStreamDo: [ :stream |
		stream nextPutAll: (self minidumpOf: {
					 (16r10000000000 -> first).
					 (16r10000000000 + first size -> second) }) ].
	[
	heap := SpurRawHeap on: (FileAddressSpace onDump: file).
	self assert: heap heldByteCount equals: first size + second size.
	self assert: heap pieces size equals: 1.
	self assert: heap mappingLimit equals: 16r10000000000 + first size + second size ] ensure: [
		heap ifNotNil: [ heap space close ].
		file ensureDelete ]
