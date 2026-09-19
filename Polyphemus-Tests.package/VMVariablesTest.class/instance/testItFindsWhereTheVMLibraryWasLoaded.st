tests
testItFindsWhereTheVMLibraryWasLoaded

	"The core lists the files mapped into the process; the VM library's first page is where
	its symbols' addresses start from."

	| library |
	library := dump mappedFiles detect: [ :each |
		           (each path endsWith: '/libPharoVMCore.so') and: [ each fileOffset = 0 ] ].

	self assert: variables base equals: library start.
	self assert: variables base \\ 4096 equals: 0
