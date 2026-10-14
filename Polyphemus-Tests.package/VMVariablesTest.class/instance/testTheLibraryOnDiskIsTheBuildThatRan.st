tests
testTheLibraryOnDiskIsTheBuildThatRan

	"An ELF library's GNU build id is 20 bytes; a Mach-O's UUID or a PE's header fields stand for
	one elsewhere. Either way, the file's is the one in memory."

	(variables library isKindOf: ElfSharedObject) ifTrue: [
		self assert: variables library buildId size equals: 20 ].
	self assert: variables library buildId notNil.
	self assert: variables buildIdInMemory equals: variables library buildId
