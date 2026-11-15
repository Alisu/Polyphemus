tests
testAMethodWhoseSelectorTakesOtherArgumentsThanItsHeaderCountsIsNotCalledByIt

	"#206: where the selector of Interval>>size was, there is collect:. A literal taken for the
	selector, as with a header that counts other literals than the method has, was shown as its name."

	| method |
	method := (reifiedMemory oopClassNamed: 'Interval') reifiedMethods detect: [ :each | each selector = #unknownSelector ].

	self
		should: [ method oopSelector ]
		raise: NotInTheReading
		withExceptionDo: [ :refusal |
			self assert: (refusal messageText endsWith: 'does not take the 0 arguments its header counts: collect:') ].
	self assert: method printString equals: 'Interval >> an unreadable selector'.
	self assert: (method inspectionItems detect: [ :each | each key = #selector ]) value isUnreadableSlot.
	self assert: ((reifiedMemory oopClassNamed: 'Interval') methodNamed: 'collect:' ifAbsent: [ nil ]) selector equals: #collect:
