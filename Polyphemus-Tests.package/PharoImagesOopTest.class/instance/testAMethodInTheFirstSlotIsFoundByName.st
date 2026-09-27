tests
testAMethodInTheFirstSlotIsFoundByName

	"#28: what the count hid, a lookup by name could not answer either. Which class holds a
	method in its first slot depends on the image."

	| class first |
	class := #( 'Integer' 'String' 'SmallInteger' 'Behavior' 'Object' )
		         detect: [ :each |
			         ((((reifiedMemory oopClassNamed: each) reifiedSlotAt: 2) reifiedSlotAt: 2)
				         reifiedSlotAt: 1) isNilOop not ]
		         ifNone: [ nil ].
	self deny: class isNil.
	class := reifiedMemory oopClassNamed: class.
	first := ((class reifiedSlotAt: 2) reifiedSlotAt: 3) asString.

	self assert: (class methodNamed: first) isCompiledMethodOop
