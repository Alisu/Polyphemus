instance creation
newFrameBelow: aStackFrame starting: start from: aCogStackPage on: aPreReifiedMemory

	| instance |
	instance := self new.
	instance
		framePointer: start;
		memory: aPreReifiedMemory;
		computeFields ;
		computeOperandStack: (aStackFrame layout callerStackEndBelow: aStackFrame framePointer);
		readSavedIPFrom: aStackFrame;
		frameAbove: aStackFrame.
	^ instance