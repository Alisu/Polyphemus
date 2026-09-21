tests
testItWritesAFixWhereTheMethodIs

	"An accepted edit whose code is the length of what it replaces goes where the method is."

	| method |
	method := self aMethodWithAComparison.
	method ifNil: [ ^ self fail: 'no method of Integer recompiles here and holds a comparison' ].

	self
		assert: (self fix
				 apply: (method getSourceFromFile copyReplaceAll: ' < ' with: ' <= ')
				 to: method)
		equals: #wroteItWhereItWas
