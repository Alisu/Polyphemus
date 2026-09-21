helpers
statementDoingNothingPutInto: aSource

	"The source with a statement that changes nothing after its first line. It compiles to a
	few bytecodes and no literal of its own: nil, nil, a special send, a jump."

	| lines |
	lines := aSource lines.
	^ ((lines first: 1) , { '	nil == nil ifTrue: [ ].' } , (lines allButFirst))
		  inject: ''
		  into: [ :all :each | all , each , (String with: Character lf) ]
