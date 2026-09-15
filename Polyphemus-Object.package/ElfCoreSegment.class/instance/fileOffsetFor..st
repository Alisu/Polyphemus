accessing
fileOffsetFor: anAddress

	"Where in the dump the byte for this address is, or nil when it was not written."

	^ (self holdsAddress: anAddress)
		  ifTrue: [ fileOffset + (anAddress - address) ]
		  ifFalse: [ nil ]
