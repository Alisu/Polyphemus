private
activeProcessAddress

	"Where the process running this moment is: specials, scheduler association, scheduler,
	activeProcess -- words read from the process itself, no copy of its heap. Call it stopped."

	| scanner scheduler |
	scanner := SpurHeapScanner on: reader.
	scheduler := scanner
		             slotOf: (scanner slotOf: ((VMVariables on: reader) at: 'specialObjectsOop') at: 4)
		             at: 2.
	^ scanner slotOf: scheduler at: 2
