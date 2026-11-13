accessing
addressOf: aName

	"As VMVariables refuses a name its library does not have."

	^ addresses at: aName ifAbsent: [ (SpurCannotRead new level: #vm reason: #theVMLibraryHasNoSuchSymbol) signal ]
