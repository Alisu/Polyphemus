reifying
reifiedMemory

	"A LazyReifiedMemory, because the full one rewrites the free lists, reading frames the
	way Cog lays them out. Refused when the class table cannot be navigated."

	| reified |
	raw readability require: #classes.
	reified := LazyReifiedMemory on: self memory.
	reified vmLayout: (OOPCogLayout on: reified raw: raw).
	^ reified
