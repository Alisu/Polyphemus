naming
identityHashOf: aReifiedProcess in: aWritableMemory

	"The hash the image will answer for that process. One is set first when it has none, or the
	image would pick its own when asked. Call it stopped, with the reading that found it."

	| address hash |
	address := aReifiedProcess address.
	hash := aWritableMemory hashBitsOf: address.
	hash = 0 ifFalse: [ ^ hash ].
	hash := ((address bitShift: -3) bitAnd: 16r3FFFFF) max: 1.
	aWritableMemory setHashBitsOf: address to: hash.
	^ hash
