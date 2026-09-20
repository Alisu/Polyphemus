writing
allocateContextOf: slots like: aFrame

	"A context of this memory's own kind, allocated by VMMaker in old space: format and class
	read from a context already there."

	| scanner header |
	scanner := dumped raw scanner.
	header := scanner headerAt: self aContextOfThisMemory.
	^ dumped memory
		  allocateSlotsInOldSpace: slots
		  format: (scanner formatIn: header)
		  classIndex: (header bitAnd: 16r3FFFFF)
