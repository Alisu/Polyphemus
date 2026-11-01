running
setUp

	super setUp.
	directory := FileLocator temp / ('stop-helper-test-' , UUID new asString).
	directory ensureCreateDirectory.
	target := self launchASleeper
