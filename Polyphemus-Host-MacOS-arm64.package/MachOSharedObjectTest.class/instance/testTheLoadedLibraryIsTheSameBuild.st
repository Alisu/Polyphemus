tests
testTheLoadedLibraryIsTheSameBuild

	"The UUID in the header mapped in memory, as VMVariables checks before believing a symbol."

	| memory mapping |
	memory := MacProcessMemory onSelf.
	mapping := memory mappedFiles detect: [ :each | (each path endsWith: '/libPharoVMCore.dylib') and: [ each fileOffset = 0 ] ].
	self assert: (self library buildIdInMemory: memory at: mapping start) equals: self library buildId
