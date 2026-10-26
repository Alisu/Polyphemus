running
tearDown

	process ifNotNil: [ process terminate ].
	super tearDown
