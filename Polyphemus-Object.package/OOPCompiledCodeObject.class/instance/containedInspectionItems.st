inspection
containedInspectionItems

	"What it says of itself, then its literals, one that does not read in its place; with a header
	that does not read the literals cannot be counted, which is said where their number is (#206)."

	| res literals |
	res := OrderedCollection new.
	res addAll: self compiledCodeInspectionItems.
	literals := self named: 'numLiterals' read: [ self allReifiedSlots allButFirst ].
	literals isArray ifFalse: [
		res add: #numLiterals -> literals.
		^ res ].
	res add: #numLiterals -> literals size.
	literals doWithIndex: [ :literal :index | res add: 'literal ' , index printString -> literal ].
	^ res
