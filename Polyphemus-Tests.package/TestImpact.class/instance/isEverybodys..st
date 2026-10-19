testing
isEverybodys: aSelector

	"Implemented past wideLimit: followed, it would reach everything."

	^ (SystemNavigation default allImplementorsOf: aSelector) size > self wideLimit
