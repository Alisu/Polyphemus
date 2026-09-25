installing
fill: anOop from: aCompilation like: aReifiedMethod

	"Filled with the literal oops the old method holds, this compilation using the same ones."

	^ self
		  fill: anOop
		  from: aCompilation
		  withLiterals: ((1 to: aCompilation numLiterals) collect: [ :each |
				   memory fetchPointer: each ofObject: aReifiedMethod address ])
