tests
testResettingTheFixtureDoesNotLeaveItsClassBehind

	"The interpreted fixture is a class built on the spot with #newSubclass, so every reset
	makes a new one. Forgetting the old class instead of removing it keeps its loaded image
	alive through TestResource's class side: 82 MB a reset, invisible until the image on
	disk has grown by an order of magnitude.

	Both halves are worth stating. Building the fixture adds exactly one class, and
	resetting it takes that one away again.

	This costs an image load, which is why it lives in the lifecycle class rather than
	beside the tests that only read the fixture."

	| before |
	self class resetResource.
	before := Pharo10ImageResource subclasses size.

	self class currentImage.
	self
		assert: Pharo10ImageResource subclasses size
		equals: before + 1.

	self class resetResource.
	self assert: Pharo10ImageResource subclasses size equals: before
