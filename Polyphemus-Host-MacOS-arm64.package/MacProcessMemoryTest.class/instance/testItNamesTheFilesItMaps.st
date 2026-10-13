tests
testItNamesTheFilesItMaps

	self assert: (MacProcessMemory onSelf mappedFiles anySatisfy: [ :each |
			 (each path endsWith: '/libPharoVMCore.dylib') and: [ each fileOffset = 0 ] ])
