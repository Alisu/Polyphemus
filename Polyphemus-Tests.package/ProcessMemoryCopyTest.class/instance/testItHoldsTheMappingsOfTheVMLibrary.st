tests
testItHoldsTheMappingsOfTheVMLibrary

	"Read-only, but where VMVariables reads the library's build id."

	| copy |
	copy := ProcessMemoryCopy of: process.
	process forget.
	self assert: (copy unsignedAt: 16r20010 size: 1) equals: 2.
	self assert: copy mappedFiles size equals: 1
