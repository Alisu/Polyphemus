writing
cogLayout

	"How Cog laid out the memory this dump holds: what reads a CogMethod."

	^ cogLayout ifNil: [
		  cogLayout := OOPCogLayout on: (LazyReifiedMemory on: dumped memory) raw: dumped raw ]
