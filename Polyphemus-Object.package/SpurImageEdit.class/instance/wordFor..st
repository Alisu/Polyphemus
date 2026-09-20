editing
wordFor: aValue

	"The word to store: an integer tagged as a SmallInteger, or an object of the reading at
	its address in the file. Nothing else -- what is stored has to be in the image already."

	aValue isInteger ifTrue: [ ^ self smallInteger: aValue ].
	(aValue isKindOf: OOPAbstractEntity) ifTrue: [ ^ self addressInFileOf: aValue ].
	^ self error: 'store a SmallInteger, or an object this image already holds'
