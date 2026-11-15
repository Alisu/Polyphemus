checking
checkSpecialObjects

	^ heap specialObjectsOop ifNil: [ #noSpecialObjectsArray ] ifNotNil: [ nil ]
