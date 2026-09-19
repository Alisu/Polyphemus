accessing
addressOf: aName

	"Where the VM kept the variable aName."

	self checkBuild.
	^ self base + ((self library addressOf: aName) ifNil: [
		   ^ self refuse: #theVMLibraryHasNoSuchSymbol ])
