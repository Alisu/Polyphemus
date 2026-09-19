reading
framesOfActiveProcess

	"From framePointer, stackPointer and instructionPointer, which the VM saves on leaving
	for C. Refused if a thread was in machine code; the frame pointer is believed only on the
	active page down to its base, the ip only inside the newest frame's method."

	| variables running page fp frames ip |
	variables := raw vmVariables.
	running := variables wasRunningMachineCode.
	running ifNil: [ ^ self refuse: #itCannotTellWhetherItWasRunningMachineCode ].
	running ifTrue: [ ^ self refuse: #itWasRunningMachineCodeWhoseFramesAreInRegisters ].
	page := variables stackPages
		        detect: [ :each | each address = (variables at: 'stackPage') ]
		        ifNone: [ ^ self refuse: #itsActivePageIsNoneOfItsPages ].
	fp := variables at: 'framePointer'.
	(fp between: page baseAddress - (variables at: 'bytesPerPage') and: page baseFP) ifFalse: [
		^ self refuse: #itsFramePointerIsNotOnItsActivePage ].
	frames := self framesFrom: fp stackTop: (variables at: 'stackPointer') - memory wordSize.
	frames last framePointer = page baseFP ifFalse: [
		^ self refuse: #itsFramesDoNotEndAtTheBaseOfItsPage ].
	ip := variables at: 'instructionPointer'.
	(self isInstructionPointer: ip inMethodOf: fp) ifTrue: [ frames first setSavedIP: ip ].
	^ frames
