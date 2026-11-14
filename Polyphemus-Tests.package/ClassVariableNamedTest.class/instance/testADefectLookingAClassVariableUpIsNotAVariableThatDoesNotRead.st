tests
testADefectLookingAClassVariableUpIsNotAVariableThatDoesNotRead

	"#118: a bug of our own in any step of the lookup read as no variable, or as one unreadable."

	#( #isNilOop #oopAllClassVariablesNames #oopClassVariableNamed: #oopSuperclass ) do: [ :each |
		| class |
		class := OOPClassWithAClassVariableThatDoesNotRead new.
		class address: 16r1000; memory: FullyReifiedMemory new.
		class failingIn: each with: [ 1 / 0 ].
		self
			should: [ class classVariableNamed: (each == #oopSuperclass ifTrue: [ 'Other' ] ifFalse: [ 'Limit' ]) ]
			raise: ZeroDivide
			description: 'a defect in ' , each ]
