installing
bindingOf: aReifiedClass

	"The association the image holds for that class, taken from a method of its own: every
	method ends with the binding of the class it was compiled in."

	| method |
	method := aReifiedClass reifiedMethods first.
	^ memory
		  fetchPointer: (reading literalCountOf: method address)
		  ofObject: method address
