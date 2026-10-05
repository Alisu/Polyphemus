tests
testAnyOtherFailureToStartIsNot

	"A VM 10 target that never started in CI, with no such message; and no log at all."

	self deny: (LiveImageTestCase vm9CouldNotMapItsHeapIn: 'VM version:5.0-Pharo 10.0.5 built on May  9 2023 16:47:43 Compiler: 5.4.0').
	self deny: (LiveImageTestCase vm9CouldNotMapItsHeapIn: '').
	self deny: (LiveImageTestCase vm9CouldNotMapItsHeapIn: nil)
