objects
setHashBitsOf: anOop to: aHash

	| header |
	header := self wordAt: anOop.
	^ self
		  wordAt: anOop
		  put: (header bitAnd: (16r3FFFFF bitShift: 32) bitInvert) + (aHash bitShift: 32)
