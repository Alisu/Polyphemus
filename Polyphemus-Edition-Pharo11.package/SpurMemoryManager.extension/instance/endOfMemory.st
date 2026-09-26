*Polyphemus-Edition-Pharo11
endOfMemory
	"Where old space ends: v10.0.5's own methods read memoryMap oldSpaceEnd where v10.0.0
	read this variable."

	^ self getMemoryMap oldSpaceEnd
