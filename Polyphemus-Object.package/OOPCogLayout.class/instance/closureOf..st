reading
closureOf: aFramePointer

	"A block activation has its closure where a method activation has its stacked receiver
	(CoInterpreter class>>initializeFrameIndices). nil for a method activation."

	| flags |
	flags := self flagsOf: aFramePointer.
	flags isBlockActivation ifFalse: [ ^ nil ].
	^ self objectAt: (self wordAt: aFramePointer + (flags numArgs + 2 * memory wordSize))
