instance creation
ofWhatAReadingReads: aReader

	"Its heap, new space, machine code and stack pages copied now, the rest read live as it was
	before (#122): the VM's own variables. Call it while aReader's process is held still."

	^ self new copyFrom: aReader stretches: (SpurRawHeap on: aReader) stretchesAReadingReads; yourself
