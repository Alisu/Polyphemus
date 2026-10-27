tests
testItRemembersAnOldObject

	self assert: (memory remember: 16r13800).
	self assert: (((memory wordAt: 16r13800) bitShift: -29) bitAnd: 1) equals: 1.
	self assert: (memory variables at: 'rememberedSetSize') equals: 1.
	self assert: (memory wordAt: 16r10100) equals: 16r13800
