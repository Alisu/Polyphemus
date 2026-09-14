updating
labelForProcess: aProcess

	^ (reifiedMemory processStates at: aProcess ifAbsent: [ #unknown ]) asString
	  , ' priority '
	  , ([ (aProcess reifiedSlotAt: reifiedMemory processPrioritySlot) asInteger printString ]
			 on: Error do: [ :e | '?' ])
	  , ' (' , (reifiedMemory contextsOfProcess: aProcess) size printString , ' frames)'
