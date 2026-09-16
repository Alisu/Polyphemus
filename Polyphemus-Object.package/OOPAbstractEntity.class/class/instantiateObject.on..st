instance creation
instantiateObject: anAddress on: memory

	(OOPImmediate canHandle: anAddress memory: memory) ifTrue: [
		^ OOPImmediate on: anAddress memory: memory ].
	^ (memory handlerForObjectAt: anAddress) on: anAddress memory: memory
