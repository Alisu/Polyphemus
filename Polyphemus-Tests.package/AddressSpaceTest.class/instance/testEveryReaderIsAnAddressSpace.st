tests
testEveryReaderIsAnAddressSpace

	"#118: the readers were nine classes under Object, what each can tell found by respondsTo:."

	#( #ByteArrayAddressSpace #FileAddressSpace #ProcessMemory #ProcessMemoryCopy #SplitAddressSpace
	   #VMMakerAddressSpace #ElfCoreDump #WindowsMinidump #SpurImageFile ) do: [ :each |
		self assert: ((Smalltalk at: each) inheritsFrom: AddressSpace) description: each , ' is not an AddressSpace' ]
