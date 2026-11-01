running
setUp

	super setUp.
	OSPlatform current isWindows ifTrue: [ ^ self skip: 'Windows has no stop helper' ].
	directory := FileLocator temp / ('stop-helper-test-' , UUID new asString).
	directory ensureCreateDirectory.
	target := self launchASleeper
