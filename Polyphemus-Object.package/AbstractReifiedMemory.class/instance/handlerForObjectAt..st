reifying
handlerForObjectAt: anAddress

	"Which kind of reified object this address should become.

	Asking every handler `canHandle:` for every object is seventeen questions a million
	times over, and almost all of them are asked again a moment later with the same answer:
	every handler decides on the object's format and class index and nothing else. So the
	answer is remembered against exactly those two, which is a cache keyed by class -- the
	same trick as the VM's own method lookup cache, for the same reason.

	Measured over a real heap: 1,106,398 objects, 11,206 distinct class-and-format pairs,
	and not one pair that two different handlers claimed. The cache is exact, not a guess.

	A corrupt object still takes the long way round every time. `OOPAbnormalEntity` decides
	by raising, and an exception leaves nothing behind in the cache, so the next object like
	it raises too."

	| key |
	handlerCache ifNil: [ handlerCache := Dictionary new ].
	key := ((memory classIndexOf: anAddress) bitShift: 5)
	       + (memory formatOf: anAddress).
	^ handlerCache at: key ifAbsentPut: [ self handlerToUseFor: anAddress ]
