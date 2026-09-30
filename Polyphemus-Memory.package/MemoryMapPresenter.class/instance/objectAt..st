accessing
objectAt: anAddress

	"The object at that address, as the reified memory has it: only that one is reified."

	^ OOPAbstractEntity newFor: anAddress memory: reifiedMemory
