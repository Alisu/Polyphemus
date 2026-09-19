tests
testClassInstancesAreCountedAgainAfterTheMemoryIsReadAgain

	"#update throws away the cached instances of a class."

	| classOop |
	classOop := self newClassInOldSpaceWithSlots: 1.
	memory ensureBehaviorHash: classOop.
	reifiedMemory update.

	self assert: (self reifyOop: classOop) instancesOop isEmpty.

	memory instantiateClass: classOop.
	reifiedMemory update.

	self assert: (self reifyOop: classOop) instancesOop size equals: 1
