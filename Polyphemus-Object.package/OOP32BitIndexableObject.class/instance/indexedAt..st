accessing-slots
indexedAt: anIndex

	"1-based, as the 8 and 64-bit ones: VMMaker counts from 0 (#88)."

	^ memory fetchLong32: anIndex - 1 ofObject: address