running
tearDown

	"Leave this image no more observable than it was found."

	LinuxObservationPermission isSupportedHere ifTrue: [
		LinuxObservationPermission denyObservers ].
	super tearDown
