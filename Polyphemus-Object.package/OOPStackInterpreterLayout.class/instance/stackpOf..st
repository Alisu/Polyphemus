reading
stackpOf: aFrame

	"Its arguments and the words of its stack, as a context counts them: what the VM's
	stackPointerIndexForFrame:WithSP: answers for it (#176)."

	^ (self flagsOf: aFrame framePointer) numArgs + aFrame stackWords size