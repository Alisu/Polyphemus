accessing
failingIn: aSelector with: aBlock

	"From now on, being sent aSelector evaluates aBlock first: a defect put where a read is."

	failingSelector := aSelector.
	failure := aBlock
