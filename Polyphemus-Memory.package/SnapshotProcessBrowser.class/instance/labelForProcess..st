updating
labelForProcess: aProcess

	"Its state, priority and frames; and why its stack ends where it does, when that is not at
	its oldest activation."

	| activations |
	activations := reifiedMemory activationsOfProcess: aProcess.
	^ (reifiedMemory processStates at: aProcess ifAbsent: [ #unknown ]) asString
	  , ' priority '
	  , ([ (aProcess reifiedSlotAt: reifiedMemory processPrioritySlot) asInteger printString ]
			 on: Error do: [ :e | '?' ])
	  , ' (' , activations size printString , ' frames'
	  , ((reifiedMemory stacks whyTheStack: activations endsForProcess: aProcess)
			   ifNil: [ '' ]
			   ifNotNil: [ :why | ', then: ' , why ]) , ')'
