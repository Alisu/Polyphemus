tests
testNoMethodSaysARefusalItsOwnWay

	| saying |
	saying := (SystemNavigation default allReferencesTo: (Smalltalk globals associationAt: #NotOnAReading))
		          reject: [ :each |
			          each methodClass instanceSide == NotOnAReading or: [
				          each methodClass category beginsWith: 'Polyphemus-Tests' ] ].
	self assert: saying notEmpty.
	saying do: [ :each |
		self deny: (each sourceCode includesSubstring: 'signal:') description: each printString ]
