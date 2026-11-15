tests
testAMethodWhoseSelectorDoesNotReadIsPassedOverAndANameNotFoundIsNotSaidAbsent

	"#205: one method of Fraction does not say its name. The others are still found by theirs; a
	name that is not found may be that one's, so it is refused and not said absent. A class with
	no such method answers absent as before."

	| fraction |
	fraction := reifiedMemory oopClassNamed: 'Fraction'.

	self assert: (fraction methodNamed: 'denominator' ifAbsent: [ nil ]) notNil.
	self
		should: [ fraction methodNamed: 'noSuchSelector' ifAbsent: [ nil ] ]
		raise: NotInTheReading
		withExceptionDo: [ :refusal | self assert: (refusal messageText includesSubstring: 'cannot be told') ].
	self assert: ((reifiedMemory oopClassNamed: 'Semaphore') methodNamed: 'noSuchSelector' ifAbsent: [ #absent ]) equals: #absent
