tests
testASpaceThatMapsNoFileSaysItHasNoVMLibrary

	"#118: bytes in hand or an image file map no library; asked for a variable they said
	doesNotUnderstand: #mappedFiles, which every caller caught as any error."

	| refusal |
	refusal := [ (VMVariables on: (ByteArrayAddressSpace on: (ByteArray new: 64) at: 16r1000)) at: 'nilObj'. nil ]
		           on: SpurCannotRead
		           do: [ :e | e ].
	self assert: refusal notNil.
	self assert: refusal level equals: #vm.
	self assert: refusal reason equals: #theVMLibraryIsNotMappedInIt
