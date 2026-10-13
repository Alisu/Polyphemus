helpers
library

	"The VM library this Pharo runs on, as its own mappings name it."

	^ MachOSharedObject on: (MacProcessMemory onSelf mappedFiles detect: [ :each |
			   (each path endsWith: '/libPharoVMCore.dylib') and: [ each fileOffset = 0 ] ]) path
