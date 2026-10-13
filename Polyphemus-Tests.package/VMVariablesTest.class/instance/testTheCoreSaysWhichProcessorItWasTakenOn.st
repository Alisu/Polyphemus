tests
testTheCoreSaysWhichProcessorItWasTakenOn

	self assert: dump processor equals: #x86_64
