tests
testItFindsTheVirtualMachinesVariables

	"As nm lists them, without Mach-O's leading underscore, relative to where the library is
	loaded: there nilObj holds where nil is (#80)."

	| library memory base |
	library := self library.
	memory := MacProcessMemory onSelf.
	base := (self vmLibraryOf: memory) start.
	self assert: (library addressOf: 'stackPage') notNil.
	self assert: (library addressOf: 'memoryMap') notNil.
	self assert: (library addressOf: 'noSuchVariable') isNil.
	self assertNilOf: memory isAt: (memory unsignedAt: base + (library addressOf: 'nilObj') size: 8)
