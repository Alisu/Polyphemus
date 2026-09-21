memory
setHashOf: anOop to: aHash

	"The identity hash lives in bits thirty-two to fifty-three of the header word."

	| header |
	header := self wordAt: anOop.
	^ self
		  wordAt: anOop
		  put: (header bitAnd: (16r3FFFFF bitShift: 32) bitInvert) + (aHash bitShift: 32)
