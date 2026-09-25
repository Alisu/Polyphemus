tests
testEachReadingHasClassesOfItsOwn

	"A new reading may take its classes over from the last one, and must then own them: a class,
	and each class it lists as a subclass, reading through the new reading and no other."

	self withTheRunawayHeldDo: [ :held :reader |
		| first second class |
		held topContext.
		first := held reading.
		held stepInto.
		held topContext.
		second := held reading.
		self deny: second == first.
		class := second oopClassNamed: 'Integer'.
		self assert: (class instVarNamed: #memory) == second.
		self assert: (class oopSubclasses allSatisfy: [ :each | (each instVarNamed: #memory) == second ]) ]
