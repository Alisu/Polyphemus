tests
testAJittedMethodCountsItsArgumentsFromItsHeaderNotItsCogMethodsAddress

	"#184: a jitted method's header slot holds its CogMethod's address; its argument and temporary
	counts read that as a header. They read the header the layout follows, as its selector says."

	| jitted |
	jitted := (self allFrames select: [ :each | each isMachineCodeFrame and: [ each isBlockContext not ] ])
		          collect: [ :each | each compiledCode ].
	self deny: jitted isEmpty.
	jitted do: [ :each |
		self deny: (memory isIntegerObject: (memory fetchPointer: 0 ofObject: each address)).
		self assert: each numArgs equals: each selector numArgs.
		self assert: each numTemps >= each numArgs ]