reading
interpreterOnImageFile: aPath

	"An image file opened in VMMaker's simulator and not started."

	| interpreter |
	interpreter := self newSimulatorInterpreter.
	interpreter openOn: aPath asFileReference fullName.
	interpreter initStackPages.
	^ interpreter
