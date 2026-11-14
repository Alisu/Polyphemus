tests
testAClassWhoseNameDoesNotReadIsPassedOverWhenOneIsSoughtByName

	"#118: its name read through a word that is no address ended the search, by a KeyNotFound of
	VMMaker's that a handler for NotFound happened to catch."

	| classOop |
	classOop := self newClassInOldSpaceWithSlots: 1.
	memory ensureBehaviorHash: classOop.
	reifiedMemory update.

	self assert: (reifiedMemory preFindClassNamed: 'NoSuchClassOfCandle' ifAbsent: [ #none ]) equals: #none
