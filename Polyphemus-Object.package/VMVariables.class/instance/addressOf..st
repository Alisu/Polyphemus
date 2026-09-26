accessing
addressOf: aName

	"Where the VM kept the variable aName: at its symbol, or where a later VM moved it
	(movedAddressOf:)."

	self checkBuild.
	(self library addressOf: aName) ifNotNil: [ :offset | ^ self base + offset ].
	^ (self movedAddressOf: aName) ifNil: [ self refuse: #theVMLibraryHasNoSuchSymbol ]
