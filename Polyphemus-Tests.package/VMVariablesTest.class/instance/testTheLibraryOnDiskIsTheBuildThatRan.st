tests
testTheLibraryOnDiskIsTheBuildThatRan

	self assert: variables library buildId size equals: 20.
	self assert: variables buildIdInMemory equals: variables library buildId
