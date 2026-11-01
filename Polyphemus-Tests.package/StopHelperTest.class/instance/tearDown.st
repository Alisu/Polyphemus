running
tearDown

	target ifNotNil: [ LibC system: 'kill -9 ' , target printString ].
	directory ifNotNil: [ directory ensureDeleteAll ].
	super tearDown
