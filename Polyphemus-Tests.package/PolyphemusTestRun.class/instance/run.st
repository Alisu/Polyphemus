running
run

	"As TestSuite>>run:, in its execution environment and with its resources; each failure is
	run once more before the resources go."

	CurrentExecutionEnvironment runTestsBy: [
		[
		suite setUp.
		suite tests do: [ :each | outcomes add: each -> (self runOnce: each) ].
		self problems do: [ :each | again at: each key put: (self runOnce: each key) ] ]
			ensure: [ suite tearDown ] ]
