tests
testItCountsTheTestsItSkipped

	"A skipped test is not a passed one: the report says how many there were."

	| suite run |
	suite := TestSuite new.
	#( #passes #skips ) do: [ :each | suite addTest: (PolyphemusTestRunExample selector: each) ].

	run := (PolyphemusTestRun of: suite) run.

	self assert: run skippedCount equals: 1
