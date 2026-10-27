tests
testItRemembersAnOldObject

	self assert: (memory remember: 16r10C00).
	self assert: (((memory wordAt: 16r10C00) bitShift: -29) bitAnd: 1) equals: 1.
	self assert: (memory variables at: 'rememberedSetSize') equals: 1.
	self assert: (memory wordAt: 16r10800) equals: 16r10C00
