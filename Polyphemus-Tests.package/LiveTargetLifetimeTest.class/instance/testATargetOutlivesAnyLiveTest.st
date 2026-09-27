tests
testATargetOutlivesAnyLiveTest

	"#55: targets ended themselves after 120 s, and a test of ~15 s alone took 140-155 s under
	the suite's load. Each test kills its target when done; left alone, one lives past the limit."

	| test |
	test := LiveEditingTest new.
	self assert: test targetLifetime seconds > test defaultTimeLimit
