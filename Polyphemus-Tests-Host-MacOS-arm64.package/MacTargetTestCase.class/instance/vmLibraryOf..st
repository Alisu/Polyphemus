helpers
vmLibraryOf: aMacProcessMemory

	"The VM library's mapping at its start, as the process names it."

	^ aMacProcessMemory mappedFiles detect: [ :each |
		  (each path endsWith: '/libPharoVMCore.dylib') and: [ each fileOffset = 0 ] ]
