helpers
aMethodWhoseComparisonCanBeSwappedIn: aReifiedClass of: aReading

	"A method of that class whose source holds a comparison, which recompiles here as the
	file has it, and whose swapped version fits where it is: {method. as it is. as swapped}."

	^ aReifiedClass reifiedMethods
		  detect: [ :each |
			  (self swapOf: each in: aReifiedClass of: aReading) notNil ]
		  ifFound: [ :each | self swapOf: each in: aReifiedClass of: aReading ]
		  ifNone: [ nil ]
