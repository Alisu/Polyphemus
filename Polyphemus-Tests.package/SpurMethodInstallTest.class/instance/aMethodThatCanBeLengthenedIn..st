helpers
aMethodThatCanBeLengthenedIn: aReifiedClass

	"A method of that class which recompiles here as the file has it and takes a statement
	that does nothing, so the code grows and the literals do not: {method. as it is. longer}."

	^ aReifiedClass reifiedMethods
		  detect: [ :each | (self lengthenedOf: each in: aReifiedClass) notNil ]
		  ifFound: [ :each | self lengthenedOf: each in: aReifiedClass ]
		  ifNone: [ nil ]
