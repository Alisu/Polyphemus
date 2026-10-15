tests
testItsProcessorIsX86

	self assert: WindowsProcessMemory onSelf processor equals: #x86_64
