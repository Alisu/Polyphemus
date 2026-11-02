guessing
soundObjectsFrom: anAddress runTo: anEnd

	| next |
	next := anAddress.
	[ next < anEnd ] whileTrue: [
		(self isSoundObjectAt: next limit: anEnd) ifFalse: [ ^ false ].
		next := memory objectAfter: next limit: anEnd ].
	^ next = anEnd
