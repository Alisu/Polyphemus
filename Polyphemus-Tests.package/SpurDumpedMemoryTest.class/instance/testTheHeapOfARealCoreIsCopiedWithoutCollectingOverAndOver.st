tests
testTheHeapOfARealCoreIsCopiedWithoutCollectingOverAndOver

	"Read 4 MB at a time, each block an old space ByteArray, the copy set off a full collection
	every few blocks, 600 ms apiece on a large heap (#87). Counted, not timed: load does not move it."

	| raw collections |
	self dumpFile exists ifFalse: [ ^ self skip: 'no core of a real VM here (bin/take-dump.sh)' ].
	raw := SpurRawHeap on: (ElfCoreDump on: self dumpFile).
	collections := Smalltalk vm parameterAt: 7.
	[ raw pieces ] ensure: [ raw space close ].
	collections := (Smalltalk vm parameterAt: 7) - collections.
	self assert: raw heldByteCount > 0.
	self assert: collections <= 2 description: [ collections printString , ' full collections' ]
