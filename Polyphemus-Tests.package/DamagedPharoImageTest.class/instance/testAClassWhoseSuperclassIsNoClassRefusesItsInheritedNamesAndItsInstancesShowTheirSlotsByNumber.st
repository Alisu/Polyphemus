tests
testAClassWhoseSuperclassIsNoClassRefusesItsInheritedNamesAndItsInstancesShowTheirSlotsByNumber

	"#205: its names were asked of the tagged word, and a superclass pointing nowhere, as Bag's,
	made the whole image unreadable at set-up. The class refuses what it inherits by name, still
	answers what it declares, and an instance shows its slots under numbers, not wrong names."

	| color instance items |
	color := reifiedMemory oopClassNamed: 'Color'.
	instance := color instancesOop first.

	self should: [ color oopSuperclass ] raise: NotInTheReading.
	self should: [ (reifiedMemory oopClassNamed: 'Bag') oopSuperclass ] raise: NotInTheReading.
	self assert: (reifiedMemory oopClassNamed: 'Bag') oopName equals: 'Bag'.
	self should: [ color allOopSlotNames ] raise: NotInTheReading.
	self assert: color oopSlotNames notEmpty.
	self assert: color oopName equals: 'Color'.
	self assert: (color classVariableNamed: color oopAllClassVariablesNames first) notNil.
	self assert: (instance printString includesSubstring: 'Color').
	items := instance inspectionItems.
	self assert: (items anySatisfy: [ :each | each key = 'slot 1' ]).
	self assert: (items noneSatisfy: [ :each | each key isString and: [ each key beginsWith: '(1)' ] ])
