tests
testOldSpaceEndsWhereTheVMSaysThoughAMappingTouchesIt

	"A mapping right after old space's last segment, as malloc's arenas come on Linux, is not old
	space when the VM says its memory ends before it: walked as such, it met a zero header (#146)."

	| scanner first touching file dump |
	scanner := SpurHeapScannerTest new.
	first := scanner heapBytesFor: scanner aFewObjects , { #( 30 2 2000 ) }.
	touching := ByteArray new: 4096.
	file := PolyphemusEdition current scratch / 'polyphemus-touched.dmp'.
	file ensureDelete.
	file binaryWriteStreamDo: [ :stream |
		stream nextPutAll: (self minidumpOf: {
					 (16r10000000000 -> first).
					 (16r10000000000 + first size -> touching) }) ].
	[
	dump := FileAddressSpace onDump: file.
	self
		assert: (SpurRawHeap limitOf: dump loadableSegments first in: dump endingBy: 16r10000000000 + first size)
		equals: 16r10000000000 + first size.
	self
		assert: (SpurRawHeap limitOf: dump loadableSegments first in: dump endingBy: nil)
		equals: 16r10000000000 + first size + touching size ] ensure: [
		dump ifNotNil: [ dump close ].
		file ensureDelete ]
