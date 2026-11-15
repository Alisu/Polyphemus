tests
testAGlobalWhoseEntryOrNameDoesNotReadIsPassedOverAndANameNotFoundIsNotSaidAbsent

	"#118: two globals do not say their names, one whose entry is a tagged word, one whose key is.
	The others are found; a name that is not found may be one of those two, so it is refused and
	not said absent, and Pharo's compiler is answered none. The key was taken for a name: '5'."

	| point |
	point := reifiedMemory oopClassNamed: 'Point'.

	self assert: (reifiedMemory globalNamed: #Smalltalk) notNil.
	self assert: (reifiedMemory globalNamed: #Transcript) notNil.
	#( #ZnConstants #ZnEasy #NoSuchGlobalAnywhere '5' ) do: [ :each |
		self
			should: [ reifiedMemory globalNamed: each ]
			raise: NotInTheReading
			withExceptionDo: [ :refusal |
				self assert: (refusal messageText includesSubstring: '2 of its globals do not read') description: each ].
		self assert: (point bindingOf: each) isNil description: each ].
	self assert: (reifiedMemory oopClassNamed: 'ZnConstants') oopName equals: 'ZnConstants'
