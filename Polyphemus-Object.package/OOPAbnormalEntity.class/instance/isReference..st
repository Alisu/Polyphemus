guessing
isReference: aWord

	^ (memory isImmediate: aWord) or: [ self isSoundObjectAt: aWord limit: memory endOfMemory ]
