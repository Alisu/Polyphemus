reading
framesFrom: aFramePointer stackPointer: aStackPointer instructionPointer: anAddress strictly: aBoolean

	"The frame pointer believed only on the active page down to its base, the ip only inside
	the newest frame's method. Strictly, an ip outside it is refused: in machine code it means
	the registers do not yet describe the newest frame (a prologue, a trampoline)."

	| variables page frames |
	variables := raw vmVariables.
	page := variables stackPages
		        detect: [ :each | each address = (variables at: 'stackPage') ]
		        ifNone: [ ^ self refuse: #itsActivePageIsNoneOfItsPages ].
	(aFramePointer between: page baseAddress - (variables at: 'bytesPerPage') and: page baseFP) ifFalse: [
		^ self refuse: #itsFramePointerIsNotOnItsActivePage ].
	frames := self framesFrom: aFramePointer stackTop: aStackPointer - memory wordSize.
	frames last framePointer = page baseFP ifFalse: [
		^ self refuse: #itsFramesDoNotEndAtTheBaseOfItsPage ].
	(self isInstructionPointer: anAddress inMethodOf: aFramePointer)
		ifTrue: [ frames first setSavedIP: anAddress ]
		ifFalse: [ aBoolean ifTrue: [ ^ self refuse: #itsInstructionPointerIsOutsideItsNewestFrame ] ].
	^ frames
