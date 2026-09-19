reading
methodOf: aFramePointer

	"The CompiledMethod or CompiledBlock. A machine code frame reaches it through its
	CogMethod's methodObject field (CogMethodSurrogate64>>methodObject)."

	(self isMachineCodeFrame: aFramePointer) ifFalse: [
		^ self wordAt: aFramePointer - memory wordSize ].
	^ self wordAt: (self cogMethodOf: aFramePointer) + (2 * memory wordSize)
