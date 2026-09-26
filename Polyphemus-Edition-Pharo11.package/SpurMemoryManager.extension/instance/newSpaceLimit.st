*Polyphemus-Edition-Pharo11
newSpaceLimit
	"As newSpaceStart: VMMaker v10.0.0's name, read from the memory map."

	^ self getMemoryMap newSpaceEnd
