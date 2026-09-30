accessing
categoryOfPixel: anIndex

	(anIndex between: 0 and: winners size - 1) ifFalse: [ ^ #nothing ].
	^ self class categories at: (winners at: anIndex + 1) + 1
