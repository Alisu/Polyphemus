reifying
reifiedMemory

	"A LazyReifiedMemory, because the full one rewrites the free lists, reading frames the way Cog
	lays them out. Refused when the class table cannot be navigated, or the special objects array
	is not found: a reading is set up from both (#211)."

	| reified |
	raw readability
		require: #classes;
		require: #specialObjects.
	reified := LazyReifiedMemory on: self memory.
	reified vmLayout: (OOPCogLayout on: reified raw: raw).
	^ reified
