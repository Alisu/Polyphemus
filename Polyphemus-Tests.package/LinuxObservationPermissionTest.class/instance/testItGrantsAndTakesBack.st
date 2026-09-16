tests
testItGrantsAndTakesBack

	"That the call reaches the kernel and is accepted -- prctl answers zero for success.

	That it *means* what it says is not tested here but in `LinuxProcessMemoryTest`, where an
	image launched with the permission is read by a process that is nothing to do with it,
	and where the same was measured both ways round: granted, a sibling could read; cleared,
	the same sibling could not."

	self assert: LinuxObservationPermission allowAnyObserver equals: 0.
	self assert: (LinuxObservationPermission allowObserver: 1) equals: 0.
	self assert: LinuxObservationPermission denyObservers equals: 0
