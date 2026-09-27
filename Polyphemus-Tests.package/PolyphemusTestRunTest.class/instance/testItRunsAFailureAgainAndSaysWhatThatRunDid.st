tests
testItRunsAFailureAgainAndSaysWhatThatRunDid

	| suite run |
	suite := TestSuite new.
	#( #passes #fails ) do: [ :each | suite addTest: (PolyphemusTestRunExample selector: each) ].

	run := (PolyphemusTestRun of: suite) run.

	self assert: (run againOf: #passes) isNil.
	self assert: ((run againOf: #fails) isKindOf: TestFailure)
