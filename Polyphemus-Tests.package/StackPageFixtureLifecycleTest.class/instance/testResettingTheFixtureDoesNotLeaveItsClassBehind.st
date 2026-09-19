tests
testResettingTheFixtureDoesNotLeaveItsClassBehind

	"Building the fixture adds exactly one class, and resetting it removes that class."

	| before |
	self class resetResource.
	before := Pharo10ImageResource subclasses size.

	self class currentImage.
	self
		assert: Pharo10ImageResource subclasses size
		equals: before + 1.

	self class resetResource.
	self assert: Pharo10ImageResource subclasses size equals: before
