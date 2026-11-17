running
setUp
	super setUp.
	widget := PolyphemusTestCase inUIProcess: [ QueryWidget new open presenter ]