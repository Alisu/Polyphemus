tests
testVM9RefusingToMapItsHeapIsRecognised

	"As CI saw it (run 36677707876, #31)."

	self assert: (LiveImageTestCase vm9CouldNotMapItsHeapIn: 'pharo-vm starting
[ERROR] 2026-09-30 06:28:41.000 sqAllocateMemory (src/memoryUnix.c:157):I cannot find a good memory address starting from: 0x16868000')
