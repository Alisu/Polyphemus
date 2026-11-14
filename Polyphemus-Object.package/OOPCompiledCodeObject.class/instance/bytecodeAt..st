accessing-bytecodes
bytecodeAt: anIndex 
	anIndex < 1 ifTrue: [ ^ self errorSubscriptBounds: anIndex ].
	anIndex > self numberOfBytecodes ifTrue: [ ^ self refuseItsLacking: 'bytecode' at: anIndex ].
	^ memory fetchByte: (self indexForBytecode: anIndex) ofObject: address
