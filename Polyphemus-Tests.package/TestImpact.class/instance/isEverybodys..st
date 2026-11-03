testing
isEverybodys: aSelector

	"Implemented past wideLimit: followed, it would reach everything."

	^ (self implementorsOf: aSelector) size > self wideLimit
