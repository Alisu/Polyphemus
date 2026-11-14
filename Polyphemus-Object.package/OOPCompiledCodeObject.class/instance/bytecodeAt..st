accessing-bytecodes
bytecodeAt: anIndex 
	(anIndex between: 1 and: self numberOfBytecodes) ifFalse: [ ^ self refuseItsLacking: 'bytecode' at: anIndex ].
	^ memory fetchByte: (self indexForBytecode: anIndex) ofObject: address
