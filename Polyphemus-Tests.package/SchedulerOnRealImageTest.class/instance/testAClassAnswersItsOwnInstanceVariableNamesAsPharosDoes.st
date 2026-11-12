tests
testAClassAnswersItsOwnInstanceVariableNamesAsPharosDoes

	"#118: instanceVariableNames is the class's own names, as Behavior's is, which Pharo's tools ask;
	allInstVarNames has the inherited ones too."

	| behavior |
	behavior := reifiedMemory allReifiedProcesses first oopClass.

	self assert: behavior name equals: 'Process'.
	self assert: behavior instanceVariableNames asArray equals: behavior instVarNames asArray.
	self deny: (behavior instanceVariableNames includes: 'nextLink').
	self assert: (behavior allInstVarNames includes: 'nextLink')