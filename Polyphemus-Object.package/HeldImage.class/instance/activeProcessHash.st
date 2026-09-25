private
activeProcessHash

	"The process running this moment, named by an identity hash in the stop that caught it:
	specials, scheduler association, scheduler, activeProcess. Call it stopped."

	| raw scanner scheduler |
	raw := (SpurDumpedMemory on: reader) raw.
	scanner := raw scanner.
	scheduler := scanner slotOf: (scanner slotOf: raw specialObjectsOop at: 4) at: 2.
	^ HeldProcess
		  identityHashOfObjectAt: (scanner slotOf: scheduler at: 2)
		  in: (SpurWritableProcess on: reader)
