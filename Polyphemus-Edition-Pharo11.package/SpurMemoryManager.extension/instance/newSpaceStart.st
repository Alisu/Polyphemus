*Polyphemus-Edition-Pharo11
newSpaceStart
	"The name VMMaker v10.0.0 gave it, which Polyphemus reads by: v10.0.5 keeps new and old
	space in its memory map, where VM 10 lays them apart."

	^ self getMemoryMap newSpaceStart
