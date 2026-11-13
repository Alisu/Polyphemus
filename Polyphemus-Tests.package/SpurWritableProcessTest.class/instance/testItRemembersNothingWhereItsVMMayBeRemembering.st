tests
testItRemembersNothingWhereItsVMMayBeRemembering

	"#167: stopped in its own code, the VM may have the remembered set's size in a register: our
	entry would take its place or lose its own. Refused in the write itself, whoever stopped it,
	before the object is marked."

	memory variables machineCode: false.
	self should: [ memory remember: 16r13800 ] raise: CannotWriteThere.
	self assert: (((memory wordAt: 16r13800) bitShift: -29) bitAnd: 1) equals: 0.
	self assert: (memory variables at: 'rememberedSetSize') equals: 0.
	memory variables machineCode: nil.
	self should: [ memory remember: 16r13800 ] raise: CannotWriteThere
