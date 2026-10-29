tests
testItSaysWhatWasAskedWhenMemoryRanOut

	"An OutOfMemory says what was asked for and how full the heap was then: run again, the flake no
	longer shows it."

	| suite run description |
	suite := TestSuite new.
	suite addTest: (PolyphemusTestRunExample selector: #runsOutOfMemory).

	run := (PolyphemusTestRun of: suite) run.

	description := run describe: (run outcomeOf: #runsOutOfMemory).
	self assert: (description includesSubstring: 'asked PolyphemusTestRunExample new: 4096 by PolyphemusTestRunExample>>#runsOutOfMemory').
	self assert: (description includesSubstring: 'MB free')
