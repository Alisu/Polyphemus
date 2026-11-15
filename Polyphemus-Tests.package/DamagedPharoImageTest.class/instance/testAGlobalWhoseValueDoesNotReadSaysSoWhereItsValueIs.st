tests
testAGlobalWhoseValueDoesNotReadSaysSoWhereItsValueIs

	"#118: the binding itself was answered as the value of a global whose value does not read."

	| point undeclared |
	point := reifiedMemory oopClassNamed: 'Semaphore'.
	undeclared := point bindingOf: #Undeclared.

	self assert: undeclared value isUnreadableSlot.
	self assert: (undeclared value printString includesSubstring: 'Undeclared does not read').
	self assert: (point bindingOf: #Object) value isClassOop
