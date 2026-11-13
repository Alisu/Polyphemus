tests
testAClassIsAskedForAMethodItMayNotHave

	"#118: finding out that a class lacks a method was an error to catch."

	| class |
	class := reifiedMemory oopClassNamed: 'Integer'.

	self assert: (class methodNamed: 'noSuchMethodOfIntegers' ifAbsent: [ #none ]) equals: #none.
	self assert: (class methodNamed: 'even' ifAbsent: [ #none ]) isCompiledMethodOop.
	self should: [ class methodNamed: 'noSuchMethodOfIntegers' ] raise: NotFound
