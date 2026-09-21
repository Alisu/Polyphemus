helpers
makeEvenOdd: aDumpedMemory through: aReader

	"The patch, where the machine is expected to have left that method alone: its header holds
	the header word rather than compiled code, so the bytecodes are what runs."

	self
		deny: (self patchEvenIn: aDumpedMemory through: aReader)
		description: 'the machine had compiled that method, and its code is not the bytecodes'
