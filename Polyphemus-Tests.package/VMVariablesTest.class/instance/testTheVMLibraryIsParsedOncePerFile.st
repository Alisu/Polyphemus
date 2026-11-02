tests
testTheVMLibraryIsParsedOncePerFile

	"Each reading has variables of its own, but the VM's library they read is parsed once for as
	long as the file stays the same: about 27 ms a parse on a Mac, twice a step (#135)."

	(OSPlatform current isUnix and: [ '/proc/self/maps' asFileReference exists ]) ifFalse: [
		^ self skip: 'this reads /proc, which only Linux has' ].
	self assert: (VMVariables on: LinuxProcessMemory onSelf) library
		identicalTo: (VMVariables on: LinuxProcessMemory onSelf) library
