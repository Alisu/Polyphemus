helpers
runawayIn: aReader

	"The target's process spinning at the priority of a user's own, read while stopped."

	^ aReader whileStopped: [
		  | reading |
		  reading := (SpurDumpedMemory on: aReader) reifiedMemory.
		  reading runnableProcesses detect: [ :each |
			  (each reifiedSlotAt: reading processPrioritySlot) asInteger = 40 ] ]
