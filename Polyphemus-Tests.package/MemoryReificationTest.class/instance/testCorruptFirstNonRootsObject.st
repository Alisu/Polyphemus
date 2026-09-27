tests
testCorruptFirstNonRootsObject

	"The first object that is not kinda special, 50888 bytes into old space, wherever the VMMaker
	in use lays that. v10.0.5 also makes perm space's remembered set on load, which v10.0.0 has no
	use for: one object more before the break."

	self corrupt: memory oldSpaceStart + 50888.

	reifiedMemory := FullyReifiedMemory on: memory.
	self assert: reifiedMemory flagErrorObjects.
	self
		assert: reifiedMemory numberOfElements
		equals: 2473 + ((memory respondsTo: #fromPermSpaceRememberedSet)
				 ifTrue: [ 1 ]
				 ifFalse: [ 0 ])
