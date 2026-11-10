tests
testASpaceThatCannotTellSaysNothing

	"Bytes in hand have no segments, no threads, no pid, no file, no stated heap; their VM is
	taken to have run on x86-64, as the readers did when a space could not say."

	| space |
	space := ByteArrayAddressSpace new.
	self assert: space loadableSegments isNil.
	self assert: (space pieceFrom: 0 upTo: 8) isNil.
	self assert: space threadRegisters isNil.
	self assert: space pid isNil.
	self assert: space file isNil.
	self assert: space specialObjectsOop isNil.
	self assert: space oldBaseAddress isNil.
	self assert: space processor equals: #x86_64
