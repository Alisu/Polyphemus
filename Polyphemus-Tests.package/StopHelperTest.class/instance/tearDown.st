running
tearDown

	LibC system: 'kill -9 ' , target printString.
	directory ensureDeleteAll.
	super tearDown
