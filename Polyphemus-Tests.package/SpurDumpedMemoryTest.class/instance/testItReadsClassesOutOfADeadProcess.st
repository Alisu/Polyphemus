tests
testItReadsClassesOutOfADeadProcess

	"Stage one's own machinery, on memory that came from a core file: the first three
	objects name their classes, and the special objects array is the one the registers say
	it is."

	| reified |
	reified := dumped reifiedMemory.

	self
		assert: (reified reifyOop: dumped heapStart) oopClass name
		equals: 'UndefinedObject'.
	self
		assert: (reified reifyOop: dumped heapStart + 16) oopClass name
		equals: 'False'.
	self
		assert: (reified reifyOop: dumped heapStart + 32) oopClass name
		equals: 'True'.
	self
		assert: reified specialObjectsOop
		equals: reified reifiedSpecialObjectArray address
