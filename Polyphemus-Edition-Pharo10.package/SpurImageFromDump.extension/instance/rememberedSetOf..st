*Polyphemus-Edition-Pharo10
rememberedSetOf: aMemory
	"Where VMMaker v10.0.0 keeps old space's remembered set: in the scavenger."

	^ aMemory scavenger
