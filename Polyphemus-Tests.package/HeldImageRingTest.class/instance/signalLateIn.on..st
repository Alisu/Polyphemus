helpers
signalLateIn: aPid on: anIndex

	"A hold's signal the VM delivers once the observer let go, as runUntil:'s fallback's can be."

	| reader |
	reader := PolyphemusMadeFor current processMemoryClass on: aPid.
	[ reader whileStopped: [ (SpurWritableProcess on: reader) signalExternalSemaphore: anIndex ] ]
		ensure: [ reader close ]
