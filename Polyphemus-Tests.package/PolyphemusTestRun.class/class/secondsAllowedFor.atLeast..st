timing
secondsAllowedFor: aTestClass atLeast: aFloor

	"What a class of tests may take before the runner calls it stuck: each of its tests its own time
	limit, never under aFloor -- a class never timed is not cut off on its first run."

	^ aFloor max: aTestClass testSelectors size * aTestClass new defaultTimeLimit asSeconds
