tests
testAGoneProcessIsNotStopped

	self deny: (StopHelper on: self aGonePid in: directory) start
