instance creation
onTheProcessThatEnteredC: aPid

	"A session on the process its VM ran when it entered C, marked with which call (#18); refused
	before anything is read, saying where the VM is, when it is not in C."

	| memory report session |
	report := Polyphemus whereIsStuck: aPid.
	report mainThread isInACCall ifFalse: [ ^ NotInTheReading signal: 'not in a C call: ' , report mainThread summary ].
	memory := Polyphemus readProcess: aPid.
	report := Polyphemus whereIsStuck: aPid reading: memory.
	report mainThread isInACCall ifFalse: [ ^ NotInTheReading signal: 'not in a C call: ' , report mainThread summary ].
	session := self onProcess: memory reifiedActiveProcess in: memory.
	session mark: report mainThread titleMark.
	^ session