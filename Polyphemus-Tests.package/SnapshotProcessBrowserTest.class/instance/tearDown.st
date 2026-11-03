running
tearDown

	browser withWindowDo: [ :window | window close ].
	super tearDown
