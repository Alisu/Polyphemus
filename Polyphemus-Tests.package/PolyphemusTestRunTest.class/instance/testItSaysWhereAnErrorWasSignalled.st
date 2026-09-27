tests
testItSaysWhereAnErrorWasSignalled

	"Read before the stack unwinds: afterwards it is gone."

	| suite run |
	suite := TestSuite new.
	suite addTest: (PolyphemusTestRunExample selector: #errs).

	run := (PolyphemusTestRun of: suite) run.

	self assert: ((run describe: (run outcomeOf: #errs)) includesSubstring: 'PolyphemusTestRunExample>>#errs')
