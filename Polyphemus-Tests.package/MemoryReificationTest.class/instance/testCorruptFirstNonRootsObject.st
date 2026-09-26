tests
testCorruptFirstNonRootsObject

	"The first object that is not kinda special, 50888 bytes into old space: old space starts
	where the VMMaker in use lays it, low for v10.0.0 and 0x10000000000 for v10.0.5."
	self corrupt: memory oldSpaceStart + 50888.

	reifiedMemory := FullyReifiedMemory on: memory.
	self assert: reifiedMemory flagErrorObjects.
	self assert: reifiedMemory numberOfElements equals: 2473.