tests
testAMethodWhoseClassIsNoClassRefusesItByNameAndStillSaysItsSelector

	"#206: the last literal of Interval>>last is a binding whose value is no class. That value
	was answered as its class."

	| method |
	method := (reifiedMemory oopClassNamed: 'Interval') methodNamed: 'last' ifAbsent: [ nil ].

	self
		should: [ method oopMethodClass ]
		raise: NotInTheReading
		withExceptionDo: [ :refusal | self assert: (refusal messageText includesSubstring: 'is no class: OOPRegularObject at') ].
	self assert: method methodClass isNil.
	self assert: method printString equals: 'an unreadable class >> #last'.
	self assert: (method inspectionItems detect: [ :each | each key = #methodClass ]) value isUnreadableSlot
