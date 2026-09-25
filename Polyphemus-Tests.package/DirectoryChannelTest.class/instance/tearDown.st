running
tearDown

	agent ifNotNil: [ agent terminate ].
	directory ensureDeleteAll.
	super tearDown
