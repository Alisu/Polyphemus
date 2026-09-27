tests
testCorruptFirstNonRootsObject

	"The first object that is not kinda special, 50888 bytes into old space, wherever the VMMaker
	in use lays that. From v10.0.5 on, perm space's remembered sets are made on load (one, two
	in v10.3): as many objects more before the break."

	self corrupt: memory oldSpaceStart + 50888.

	reifiedMemory := FullyReifiedMemory on: memory.
	self assert: reifiedMemory flagErrorObjects.
	self
		assert: reifiedMemory numberOfElements
		equals: 2473 + (memory class allInstVarNames count: [ :each |
				  (each beginsWith: 'fromPerm') and: [ each endsWith: 'RememberedSet' ] ])
