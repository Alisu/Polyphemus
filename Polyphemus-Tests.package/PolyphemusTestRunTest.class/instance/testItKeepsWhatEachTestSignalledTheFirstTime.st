tests
testItKeepsWhatEachTestSignalledTheFirstTime

	"#31: the runner's retry of a failure ran it again and said only what that run did."

	| suite run |
	suite := TestSuite new.
	#( #passes #fails #errs #skips ) do: [ :each |
		suite addTest: (PolyphemusTestRunExample selector: each) ].

	run := (PolyphemusTestRun of: suite) run.

	self assert: (run outcomeOf: #passes) equals: #passed.
	self assert: (run outcomeOf: #skips) equals: #skipped.
	self assert: ((run outcomeOf: #fails) isKindOf: TestFailure).
	self assert: (run outcomeOf: #fails) messageText equals: 'on purpose'.
	self assert: ((run outcomeOf: #errs) isKindOf: ZeroDivide).
	self assert: run runCount equals: 4.
	self assert: run failureCount equals: 1.
	self assert: run errorCount equals: 1
