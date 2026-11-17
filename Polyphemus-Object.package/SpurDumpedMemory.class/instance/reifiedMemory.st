reifying
reifiedMemory

	"A LazyReifiedMemory, reading frames the way Cog lays them out, which lists by class through
	this memory's walk until every object is reified. Refused when the class table cannot be
	navigated or the special objects array is not found: a reading is set up from both (#211)."

	| reified |
	raw readability
		require: #classes;
		require: #specialObjects.
	reified := LazyReifiedMemory on: self memory.
	reified vmLayout: (OOPCogLayout on: reified raw: raw).
	^ reified
		  completeFrom: self;
		  yourself
