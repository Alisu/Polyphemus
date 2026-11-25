tests
testTheHeldStackIsReadWithoutAskingTheImage

	"#215: the image was asked voidCogVMState before each reading of the held stack, its frames
	being on stack pages; they are read there, and the image is asked nothing."

	self withTheRunawayHeldDo: [ :held :reader |
		| asked stack |
		asked := held channel instVarNamed: 'count'.
		stack := held contexts.
		self deny: stack isEmpty.
		self assert: (held channel instVarNamed: 'count') equals: asked ]
