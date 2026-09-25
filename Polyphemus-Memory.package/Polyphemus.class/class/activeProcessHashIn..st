private
activeProcessHashIn: aStoppedReader

	"The process running at this moment -- what the image is busy with -- named by an identity
	hash in the stop that caught it: specials, scheduler association, scheduler, activeProcess."

	| raw scanner scheduler |
	raw := (SpurDumpedMemory on: aStoppedReader) raw.
	scanner := raw scanner.
	scheduler := scanner slotOf: (scanner slotOf: raw specialObjectsOop at: 4) at: 2.
	^ HeldProcess
		  identityHashOfObjectAt: (scanner slotOf: scheduler at: 2)
		  in: (SpurWritableProcess on: aStoppedReader)
