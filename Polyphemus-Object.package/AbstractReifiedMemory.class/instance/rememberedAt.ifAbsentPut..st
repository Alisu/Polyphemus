globals
rememberedAt: aKey ifAbsentPut: aBlock

	"Anything worked out from the object graph and worth keeping until the graph is read
	again: the variable objects wrapping its globals, the methods compiled from its source.
	All of it is dropped by #forgetWhatWasRead."

	wrappedVariables ifNil: [ wrappedVariables := Dictionary new ].
	^ wrappedVariables at: aKey ifAbsentPut: aBlock
