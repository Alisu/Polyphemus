editing
codeOf: aCompilation

	"The bytecodes of a method compiled here, without its header, literals or trailer."

	^ (aCompilation initialPC to: aCompilation endPC) collect: [ :each |
		  aCompilation at: each ]
