private
activeProcessHash

	"The process running this moment, named by an identity hash in the stop that caught it:
	specials, scheduler association, scheduler, activeProcess -- four words read from the
	process itself, no copy of its heap. Call it stopped."

	| scanner scheduler |
	scanner := SpurHeapScanner on: reader.
	scheduler := scanner
		             slotOf: (scanner slotOf: ((VMVariables on: reader) at: 'specialObjectsOop') at: 4)
		             at: 2.
	^ HeldProcess
		  identityHashOfObjectAt: (scanner slotOf: scheduler at: 2)
		  in: (SpurWritableProcess on: reader)
