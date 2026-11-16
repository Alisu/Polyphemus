checking
checkSpecialObjects

	"No array, or one stated that does not start with nil, false and true: no other array of
	that shape is taken in its place (#207)."

	heap specialObjectsOop ifNotNil: [ ^ nil ].
	^ heap statedArrayWithoutItsShape
		  ifNil: [ #noSpecialObjectsArray ]
		  ifNotNil: [ #theStatedArrayDoesNotStartWithNilFalseAndTrue ]
