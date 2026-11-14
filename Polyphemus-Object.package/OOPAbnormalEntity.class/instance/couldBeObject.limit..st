testing
couldBeObject: couldBeObjAddress limit: limitAddress

	"Whether the word could be an object ending by limitAddress: VMMaker's checks of an oop, on
	its address, its size and its header, answered rather than raised."

	| classIndex fmt unusedBits unusedBitsInYoungObjects |
	(memory addressCouldBeObj: couldBeObjAddress) ifFalse: [ ^ false ].
	(memory oop: (memory addressAfter: couldBeObjAddress) isLessThanOrEqualTo: limitAddress) ifFalse: [ ^ false ].

	"A free chunk or a bridge is no object; nor is an overflow header without its saturated count."
	(classIndex := memory classIndexOf: couldBeObjAddress) >= memory firstClassIndexPun ifFalse: [ ^ false ].
	((memory rawNumSlotsOf: couldBeObjAddress) = memory numSlotsMask
	 and: [(memory rawNumSlotsOf: couldBeObjAddress - memory baseHeaderSize) ~= memory numSlotsMask]) ifTrue: [ ^ false ].

	"A format no object has, or a forwarder by only one of its format and its class index."
	fmt := memory formatOf: couldBeObjAddress.
	(fmt = 6) | (fmt = 8) ifTrue: [ ^ false ].
	(fmt = memory forwardedFormat) ~= (classIndex = memory isForwardedObjectClassIndexPun) ifTrue: [ ^ false ].

	"Header bits no object sets, and those only an old object does."
	unusedBits := (1 << memory classIndexFieldWidth)
				   bitOr: (1 << (memory identityHashFieldWidth + 32)).
	((memory long64At: couldBeObjAddress) bitAnd: unusedBits) ~= 0 ifTrue: [ ^ false ].

	unusedBitsInYoungObjects := ((1 << memory greyBitShift)
								   bitOr: (1 << memory pinnedBitShift))
								   bitOr: (1 << memory rememberedBitShift).
	((memory longAt: couldBeObjAddress) bitAnd: unusedBitsInYoungObjects) ~= 0 ifTrue: [ ^ false ].
	^ true
