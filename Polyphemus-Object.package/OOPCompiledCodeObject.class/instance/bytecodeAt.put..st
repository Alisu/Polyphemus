accessing-bytecodes
bytecodeAt: anIndex put: aBytecode
	"Currently not supported to add bytecodes"
	(anIndex between: 1 and: self numberOfBytecodes) ifFalse: [ ^ self refuseItsLacking: 'bytecode' at: anIndex ].
	memory storeByte: (self indexForBytecode: anIndex) ofObject: address withValue: aBytecode
