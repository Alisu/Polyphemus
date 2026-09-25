naming
identityHashOfObjectAt: anAddress in: aWritableMemory

	"The hash the image will answer for the object there. One is set first when it has none, or
	the image would pick its own when asked. Call it stopped, with the address just read."

	| hash |
	hash := aWritableMemory hashBitsOf: anAddress.
	hash = 0 ifFalse: [ ^ hash ].
	hash := ((anAddress bitShift: -3) bitAnd: 16r3FFFFF) max: 1.
	aWritableMemory setHashBitsOf: anAddress to: hash.
	^ hash
