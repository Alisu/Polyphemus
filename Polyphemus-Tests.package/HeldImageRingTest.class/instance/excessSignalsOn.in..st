helpers
excessSignalsOn: anIndex in: aPid

	"The signals the semaphore at anIndex of the external objects table holds, nobody taking them."

	| reader |
	reader := PolyphemusMadeFor current processMemoryClass on: aPid.
	^ [ reader whileStopped: [ | memory |
		    memory := SpurWritableProcess on: reader.
		    (memory wordAt: (memory excessSignalsOfExternalSemaphore: anIndex)) >> 3 ] ]
		  ensure: [ reader close ]
