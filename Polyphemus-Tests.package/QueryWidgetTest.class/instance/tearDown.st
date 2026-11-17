running
tearDown
	PolyphemusTestCase inUIProcess: [ widget owner close ].
	super tearDown