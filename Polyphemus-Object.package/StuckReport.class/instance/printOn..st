printing
printOn: aStream

	aStream nextPutAll: 'Process ' , pid printString , ': ' , self mainThread summary; lf.
	smalltalkAboveC ifNotNil: [ aStream nextPutAll: '  Smalltalk above the C call: ' , smalltalkAboveC; lf ].
	self mainThread isInACCall ifTrue: [ aStream nextPutAll: '  to go on in C: ' , self nativeDebuggerCommand; lf ].
	threads do: [ :each | aStream nextPutAll: '  ' , (self descriptionOf: each); lf ].
	aStream nextPutAll: '  catches ' , (' ' join: caughtSignals); lf.
	stoppedToLook ifTrue: [
		aStream nextPutAll: '  (it was running: stopped for a moment to look, then let go)'; lf ]
