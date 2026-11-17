reifying
reifiedMemory

	"A LazyReifiedMemory, reading frames the way Cog lays them out, which lists by class through
	this memory's walk until every object is reified. Refused when the class table cannot be
	navigated or the special objects array is not found: a reading is set up from both (#211)."

	| reified |
	raw readability
		require: #classes;
		require: #specialObjects.
	"Setting it up reads classes: one past where the heap's walk stopped is refused saying that."
	reified := [ LazyReifiedMemory on: self memory ]
		           on: NotInTheReading
		           do: [ :refusal |
			           raw whyItsHeapEndsEarly
				           ifNil: [ refusal pass ]
				           ifNotNil: [ :why | NotInTheReading signal: refusal messageText , why ] ].
	reified vmLayout: (OOPCogLayout on: reified raw: raw).
	^ reified
		  completeFrom: self;
		  yourself
