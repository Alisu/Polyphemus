guessing
ends
	"Where the object at the start of this gap may end: where sound objects begin that run to the
	end of the gap, or the end of the gap."

	| end |
	end := address + size.
	^ ((address + (2 * memory bytesPerOop) to: end - memory bytesPerOop by: memory bytesPerOop)
		   detect: [ :each | self soundObjectsFrom: each runTo: end ]
		   ifFound: [ :each | { each. end } ]
		   ifNone: [ { end } ])
