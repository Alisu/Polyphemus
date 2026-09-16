running
setUp

	super setUp.
	LinuxObservationPermission isSupportedHere ifFalse: [
		^ self skip: 'granting observation this way is Linux only' ]
