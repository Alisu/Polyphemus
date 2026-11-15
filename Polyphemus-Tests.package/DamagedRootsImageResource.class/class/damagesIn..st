damages
damagesIn: aCleanReading

	"The scheduler's process lists and the globals' array, each a tagged word; and the selector
	of one method of CompiledMethod class zeroed, the class asked how trailers are written."

	| scheduler globals method |
	scheduler := aCleanReading processes reifiedScheduler.
	globals := aCleanReading reifiedSmalltalk reifiedSlotAt: 1.
	method := (aCleanReading oopClassNamed: 'CompiledMethod') oopClass reifiedMethods detect: [ :each |
		          each isCompiledMethodOop ].
	^ {
		  ((DamagedCandleImage slot: aCleanReading processes processListsSlot of: scheduler) -> self taggedWord).
		  ((DamagedCandleImage slot: 2 of: globals) -> self taggedWord).
		  ((DamagedCandleImage slot: method numberOfLiterals of: method) -> 0) }
