reifying
reifyAllOops

	"Every object VMMaker's walk gives, reified. Where VMMaker asserts on what the walk meets, a
	header of zero or a class index past the class table, refused by name with the last object
	it gave (#207)."

	| last |
	[
	[
	memory allObjectsDo: [ :anOop |
		last := anOop.
		self objectAt: anOop put: (OOPAbstractEntity instantiateObject: anOop on: self) ] ]
		on: AssertionFailure
		do: [ :asserted |
			^ SpurCannotRead new
				  level: #objects reason: #theSimulatorsWalkStopped;
				  detail: 'after the object at ' , ((last ifNil: [ 0 ]) printStringRadix: 16) , ', ' , (ForeignCode whereInVMMaker: asserted);
				  signal ] ]
		on: OopIsNotAnObject
		do: [ :e |
			self addObjectHandler: OOPAbnormalEntity.
			lastKnownObject := self findObjectBefore: e oop.
			flagErrorObjects := true.
			self reifyMemoryThroughRoots ].

	flagErrorFreeTree ifTrue: [ self reconstructFreeLists ].
	memory allFreeObjectsDo: [ :anOop | 
		self objectAt: anOop put: (OOPFreeObject on: anOop memory: self) ]