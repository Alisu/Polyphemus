*Polyphemus-Edition-Pharo11
isOldObject: anOop
	"Asked of the memory map in VMMaker v10.0.5, where perm space is a third answer."

	^ self getMemoryMap isOldObject: anOop
