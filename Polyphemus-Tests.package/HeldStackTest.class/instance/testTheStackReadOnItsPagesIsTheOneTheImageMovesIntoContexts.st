tests
testTheStackReadOnItsPagesIsTheOneTheImageMovesIntoContexts

	"#215: the frames read on the stack pages are the contexts the image makes of them."

	self withTheRunawayHeldDo: [ :held :reader |
		| shown onPages inContexts |
		shown := [ :stack | stack asArray collect: [ :each | each selector -> each pc ] ].
		onPages := shown value: held contexts.
		held request: 'Smalltalk vm voidCogVMState. nil'.
		inContexts := shown value: held contexts.
		self deny: onPages isEmpty.
		self assert: onPages equals: inContexts ]
