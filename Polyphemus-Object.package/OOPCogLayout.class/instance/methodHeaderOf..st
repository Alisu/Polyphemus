reading
methodHeaderOf: aMethodOop

	"Cog puts the address of a compiled method's CogMethod in its header slot and keeps the
	header in the CogMethod (CogMethodSurrogate64>>methodHeader). Believed only if the
	CogMethod's methodObject points back (#3)."

	| slot |
	slot := memory fetchPointer: 0 ofObject: aMethodOop.
	(memory isIntegerObject: slot) ifTrue: [ ^ slot ].
	((raw isMachineCodeAddress: slot) and: [
		 (self wordAt: slot + (2 * memory wordSize)) = aMethodOop ]) ifFalse: [
		^ (SpurCannotRead new
			   level: #object
			   reason: #itsHeaderIsNeitherAHeaderNorACogMethodOfIt) signal ].
	^ self wordAt: slot + (3 * memory wordSize)
