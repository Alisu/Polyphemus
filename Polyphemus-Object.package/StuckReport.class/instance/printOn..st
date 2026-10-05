printing
printOn: aStream

	aStream nextPutAll: 'Process ' , pid printString , ': ' , self mainThread summary; lf.
	threads do: [ :each | aStream nextPutAll: '  ' , (self descriptionOf: each); lf ].
	aStream nextPutAll: '  catches ' , (' ' join: caughtSignals); lf.
	stoppedToLook ifTrue: [
		aStream nextPutAll: '  (it was running: stopped for a moment to look, then let go)'; lf ]
