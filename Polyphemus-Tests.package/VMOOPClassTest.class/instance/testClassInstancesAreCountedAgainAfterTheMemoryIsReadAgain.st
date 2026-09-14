tests
testClassInstancesAreCountedAgainAfterTheMemoryIsReadAgain

	"Finding the instances of a class is a walk over the whole heap, so the answer is kept.
	Keeping an answer about an object graph is only safe while the graph is the same one,
	and a kept answer that has quietly gone stale is worse than a slow one: it reports a
	memory that no longer exists.

	Reading the memory again is what #update does, and it has to throw the kept answer
	away."

	| classOop |
	classOop := self newClassInOldSpaceWithSlots: 1.
	memory ensureBehaviorHash: classOop.
	reifiedMemory update.

	self assert: (self reifyOop: classOop) instancesOop isEmpty.

	memory instantiateClass: classOop.
	reifiedMemory update.

	self assert: (self reifyOop: classOop) instancesOop size equals: 1
