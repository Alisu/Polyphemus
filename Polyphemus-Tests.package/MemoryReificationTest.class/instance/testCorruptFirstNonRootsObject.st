tests
testCorruptFirstNonRootsObject

	"The first object that is not kinda special, 50888 bytes into old space: old space starts
	where the VMMaker in use lays it, low for v10.0.0 and 0x10000000000 for v10.0.5. Loading
	the image, v10.0.5 also makes perm space's remembered set, an array v10.0.0 has no use for:
	one object more before the break."

	self corrupt: memory oldSpaceStart + 50888.

	reifiedMemory := FullyReifiedMemory on: memory.
	self assert: reifiedMemory flagErrorObjects.
	self
		assert: reifiedMemory numberOfElements
		equals: 2473 + ((memory respondsTo: #fromPermSpaceRememberedSet)
				 ifTrue: [ 1 ]
				 ifFalse: [ 0 ])
