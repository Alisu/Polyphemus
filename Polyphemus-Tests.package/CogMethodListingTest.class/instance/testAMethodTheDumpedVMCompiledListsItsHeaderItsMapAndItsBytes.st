tests
testAMethodTheDumpedVMCompiledListsItsHeaderItsMapAndItsBytes

	"#95: of the methods on the stacks of the core, those Cog had compiled list their CogMethod,
	its map and its bytes, and the layout answers the same text; the others list nothing."

	| memory layout listing addresses compiled |
	DamagedCoreTest hasAnElfCore ifFalse: [ ^ self skip: 'no ELF core here; make one with bin/take-dump.sh' ].
	memory := self class memory.
	layout := memory vmLayout.
	listing := CogMethodListing on: layout.
	addresses := Set new.
	memory allReifiedProcesses do: [ :process |
		(memory activationsOfProcess: process) do: [ :each |
			[ addresses add: each method address ]
				on: PolyphemusError
				do: [ :unread | nil ] ] ].
	compiled := addresses select: [ :each | (layout cogMethodAddressOf: each) notNil ].
	compiled ifEmpty: [ ^ self skip: 'Cog had compiled no method on a stack of this core' ].
	compiled do: [ :each |
		| text |
		text := listing textOf: each.
		self assert: (text beginsWith: 'CogMethod at 16r' , (layout cogMethodAddressOf: each) printStringHex).
		self assert: (text includesSubstring: 'Map: machine code pc').
		self assert: (text includesSubstring: 'Bytes').
		self assert: (layout machineCodeTextOf: each) equals: text ].
	(addresses reject: [ :each | compiled includes: each ]) do: [ :each |
		self assert: (listing textOf: each) isNil ]
