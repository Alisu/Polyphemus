instance creation
interpreterOnImageFile: aPath

	"An image file opened in VMMaker's simulator and not started. VMMaker's loader asserts on a
	file it does not expect, each version in its own places: whatever it raises is refused by
	name, with the steps of VMMaker it failed in (#207)."

	| interpreter |
	interpreter := self newInterpreter.
	ForeignCode
		askingVMMaker: [
			interpreter openOn: aPath asFileReference fullName.
			interpreter initStackPages ]
		ifItFails: [ :raised |
			^ SpurCannotRead new
				  level: #image reason: #theSimulatorDidNotLoadIt;
				  detail: (ForeignCode whereInVMMaker: raised);
				  signal ].
	^ interpreter