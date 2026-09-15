running
tearDown

	dumpFile ifNotNil: [ dumpFile ensureDelete ].
	super tearDown
