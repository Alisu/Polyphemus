tests
testItSaysWhichStatementFailed

	"Where a test has several assertions alike, the frames alone do not say which one it was."

	| suite run |
	suite := TestSuite new.
	suite addTest: (PolyphemusTestRunExample selector: #fails).

	run := (PolyphemusTestRun of: suite) run.

	self assert: ((run describe: (run outcomeOf: #fails)) includesSubstring: 'self fail: ''on purpose''')
