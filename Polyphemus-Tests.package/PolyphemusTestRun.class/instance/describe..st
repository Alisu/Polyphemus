printing
describe: anOutcome

	anOutcome isSymbol ifTrue: [ ^ anOutcome asString ].
	^ anOutcome class name , ' ' , (anOutcome messageText ifNil: [ '' ]) asString , ' [in '
	  , (places at: anOutcome ifAbsent: [ '?' ]) , ']'
