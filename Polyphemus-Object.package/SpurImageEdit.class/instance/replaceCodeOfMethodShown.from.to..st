editing
replaceCodeOfMethodShown: aReifiedMethod from: anOldCompilation to: aNewCompilation

	"Write bytecodes compiled here over a method the reading shows: rung 1 of #25, which
	keeps the method's header, literals and trailer, so the new code must be the same length
	and mean the same literals."

	| old new address |
	anOldCompilation literals = aNewCompilation literals ifFalse: [
		^ self error: 'the new code does not use the same literals' ].
	old := self codeOf: anOldCompilation.
	new := self codeOf: aNewCompilation.
	old size = new size ifFalse: [
		^ self error: 'the new code is ' , new size printString , ' bytes where there is room for '
			, old size printString ].
	address := (self addressInFileOf: aReifiedMethod) + 8 + (anOldCompilation initialPC - 1).
	(self codeAt: address ofSize: old size) = old ifFalse: [
		^ self error: 'the file does not hold the code this was compiled from' ].
	^ self storeBytes: new asByteArray at: address
