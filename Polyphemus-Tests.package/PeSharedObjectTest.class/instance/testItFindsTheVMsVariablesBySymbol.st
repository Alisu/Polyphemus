tests
testItFindsTheVMsVariablesBySymbol

	"Static variables too, from the COFF symbol table MinGW keeps: offsets from the image base,
	as nm reads them in the VM v10.3.11 build the edition pins."

	self assert: (library addressOf: 'stackPointer') equals: 16rFDB88.
	self assert: (library addressOf: 'framePointer') equals: 16rFDB98.
	self assert: (library addressOf: 'specialObjectsOop') equals: 16rFDC00.
	self assert: (library addressOf: 'noSuchVariable') isNil.
	self assert: (library variableNames includes: 'framePointer')
