tests
testItGrantsAndTakesBack

	"The call reaches the kernel and is accepted (prctl answers 0). That it works is tested in
	LinuxProcessMemoryTest, reading an image launched with it."

	self assert: LinuxObservationPermission allowAnyObserver equals: 0.
	self assert: (LinuxObservationPermission allowObserver: 1) equals: 0.
	self assert: LinuxObservationPermission denyObservers equals: 0
