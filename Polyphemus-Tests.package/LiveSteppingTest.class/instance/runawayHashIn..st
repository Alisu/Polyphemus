helpers
runawayHashIn: aReader

	"The identity hash of the target's process spinning at a user's priority, found and made
	sure of in one stop: a young object can move while the agent runs, its hash cannot."

	^ aReader whileStopped: [
		  | reading runaway |
		  reading := (SpurDumpedMemory on: aReader) reifiedMemory.
		  runaway := reading runnableProcesses detect: [ :each |
			             (each reifiedSlotAt: reading processPrioritySlot) asInteger = 40 ].
		  HeldProcess identityHashOf: runaway in: (SpurWritableProcess on: aReader) ]
