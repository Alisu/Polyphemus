tests
testAClassIsAllowedTheTimeItsTestsMayTake

	"A class never timed got a flat 400 s, and a class of long live tests timed out on its first run
	(HeldImageEditingTest, seven tests of up to four minutes): it is given what its tests may take."

	| perTest |
	perTest := HeldImageEditingTest new defaultTimeLimit asSeconds.
	self
		assert: (PolyphemusTestRun secondsAllowedFor: HeldImageEditingTest atLeast: 400)
		equals: HeldImageEditingTest testSelectors size * perTest.
	self assert: (PolyphemusTestRun secondsAllowedFor: PolyphemusTestRunTest atLeast: 400) equals: 400
