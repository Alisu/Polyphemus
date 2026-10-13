tests
testItFindsTheVirtualMachinesVariables

	"As nm lists them, without Mach-O's leading underscore."

	| library |
	library := self library.
	self assert: (library addressOf: 'nilObj') equals: 16rD80A0.
	self assert: (library addressOf: 'stackPage') equals: 16rD80C0.
	self assert: (library addressOf: 'memoryMap') equals: 16rD8058.
	self assert: (library addressOf: 'noSuchVariable') isNil
