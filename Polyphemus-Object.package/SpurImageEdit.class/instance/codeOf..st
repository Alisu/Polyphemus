editing
codeOf: aCompiledMethod

	"The bytecodes of a method compiled here, without its header, literals or trailer."

	^ (aCompiledMethod initialPC to: aCompiledMethod endPC) collect: [ :each |
		  aCompiledMethod at: each ]
