tests
testAMethodWhoseHeaderIsDamagedInTheFileIsPrintedAndInspectedSayingSoAndAnswersTheToolsWithoutIt

	"#206 on a core: the header of Interval>>first points at an object, which is neither a header
	nor a CogMethod of it. Its literals cannot be counted, so neither its class nor its selector
	is known: what Pharo's tools ask of any method is answered, what is asked of its header refused."

	| method |
	method := self class methodDamaged ifNil: [ ^ self skip: 'no Interval>>first in this core' ].

	self assert: method isCompiledMethodOop.
	self assert: method printString equals: 'an unreadable class >> an unreadable selector'.
	self assert: method selector equals: #unknownSelector.
	self assert: method methodClass isNil.
	self assert: method argumentNames isEmpty.
	self assert: (method propertyAt: #anyProperty ifAbsent: [ #absent ]) equals: #absent.
	self assert: (method sourceNodeForPC: 1) class equals: OOPUnknownSourceNode.
	self assert: (method inspectionItems detect: [ :each | each key = #numLiterals ]) value isUnreadableSlot.
	self should: [ method numberOfLiterals ] raise: SpurCannotRead.
	self should: [ method allSymbolicBytecodes ] raise: SpurCannotRead.
	self
		should: [ (memory oopClassNamed: 'Interval') methodNamed: 'noSuchSelector' ifAbsent: [ nil ] ]
		raise: NotInTheReading
