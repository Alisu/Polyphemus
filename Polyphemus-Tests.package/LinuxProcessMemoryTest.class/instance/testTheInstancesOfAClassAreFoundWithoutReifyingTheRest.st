tests
testTheInstancesOfAClassAreFoundWithoutReifyingTheRest

	"The processes of a running VM read lazily: found by a walk by class over the heap, the same as
	every object reified then asked for its class (#129)."

	| pid memory tag found |
	pid := self launchObservableTarget.
	[
	memory := Polyphemus readProcess: pid.
	tag := (memory oopClassNamed: 'Process') oopHash.
	found := memory instancesOfClassTag: tag.
	self assert: found notEmpty.
	self
		assert: (found collect: [ :each | each address ]) asSet
		equals: ((memory select: [ :each | each oopClassTag = tag ]) collect: [ :each | each address ]) asSet ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
