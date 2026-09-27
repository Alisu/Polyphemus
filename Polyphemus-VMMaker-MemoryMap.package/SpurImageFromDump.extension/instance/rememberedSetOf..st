*Polyphemus-VMMaker-MemoryMap
rememberedSetOf: aMemory
	"Where VMMaker v10.0.5 keeps old space's remembered set: a VMRememberedSet of its own,
	perm space's beside it."

	^ aMemory fromOldSpaceRememberedSet
