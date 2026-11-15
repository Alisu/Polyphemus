accessing
literalAt: anIndex

	literals ifNil: [ self readLiterals ].
	^ literals at: anIndex
