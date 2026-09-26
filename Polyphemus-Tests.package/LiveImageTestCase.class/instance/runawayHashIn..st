helpers
runawayHashIn: aReader

	"The identity hash of the target's process spinning at a user's priority, found and made
	sure of in one stop: a young object can move while the agent runs, its hash cannot. The
	first process in the scheduler's list for priority 40, read word by word from the process."

	^ aReader whileStopped: [
		  | scanner scheduler lists runaway |
		  scanner := SpurHeapScanner on: aReader.
		  scheduler := scanner
			               slotOf: (scanner slotOf: ((VMVariables on: aReader) at: 'specialObjectsOop') at: 4)
			               at: 2.
		  lists := scanner slotOf: scheduler at: 1.
		  runaway := scanner slotOf: (scanner slotOf: lists at: 40) at: 1.
		  HeldProcess identityHashOfObjectAt: runaway in: (SpurWritableProcess on: aReader) ]
