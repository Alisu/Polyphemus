accessing
at: aName

	^ values at: aName ifAbsent: [ (SpurCannotRead new level: #vm reason: #theVMLibraryHasNoSuchSymbol) signal ]
