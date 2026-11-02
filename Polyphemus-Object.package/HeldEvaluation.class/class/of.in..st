instance creation
of: anAnswer in: aHeldReading

	"anAnswer is the agent's: the class index, the identity hash or immediate value, then the print
	string, a line each."

	| rest |
	rest := anAnswer copyAfter: Character lf.
	^ self new
		  setClassIndex: (anAnswer copyUpTo: Character lf) asInteger
		  which: (rest copyUpTo: Character lf)
		  printed: (rest copyAfter: Character lf)
		  in: aHeldReading
