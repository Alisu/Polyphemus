accessing
reifiedSlotAt: anIndex

	anIndex = 2 ifTrue: [
		^ (failure ifNil: [ [ NotInTheReading signal: 'its word points nowhere' ] ]) value ].
	^ anIndex
