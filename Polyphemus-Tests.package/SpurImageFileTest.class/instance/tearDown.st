running
tearDown

	opened do: [ :each | each close ].
	super tearDown
