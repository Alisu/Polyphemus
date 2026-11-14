accessing-bytecodes
bytecodeAt: anIndex put: aBytecode
	"Currently not supported to add bytecodes"
	anIndex < 1 ifTrue: [ ^ self errorSubscriptBounds: anIndex ].
	anIndex > self numberOfBytecodes ifTrue: [ ^ self refuseItsLacking: 'bytecode' at: anIndex ].
	memory storeByte: (self indexForBytecode: anIndex) ofObject: address withValue: aBytecode
