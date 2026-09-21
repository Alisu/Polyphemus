installing
bindingOf: aReifiedClass

	"The association the image holds for that class, taken from a method of its own: every
	method ends with the binding of the class it was compiled in."

	| method |
	method := aReifiedClass reifiedMethods first.
	^ process
		  unsignedAt: method address + 8 + ((reading literalCountOf: method address) * 8)
		  size: 8
