accessing
reifiedSlotAt: anIndex

	anIndex = 2 ifTrue: [ ^ self error: 'its word points nowhere' ].
	^ anIndex
