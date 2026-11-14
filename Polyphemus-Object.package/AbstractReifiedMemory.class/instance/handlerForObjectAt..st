reifying
handlerForObjectAt: anAddress

	"The handler class for the object at anAddress, cached by class index and format, the
	only things handlers look at. Corrupt objects raise and are never cached; a word VMMaker
	holds no memory for is refused by name."

	| key |
	handlerCache ifNil: [ handlerCache := Dictionary new ].
	key := self
		       readAt: anAddress
		       through: [ ((memory classIndexOf: anAddress) bitShift: 5) + (memory formatOf: anAddress) ].
	^ handlerCache at: key ifAbsentPut: [ self handlerToUseFor: anAddress ]
