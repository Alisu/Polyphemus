tests
testFrameBelowCountsFromTheDebuggersFrame

	| session |
	process := [ Semaphore new wait ] newProcess.
	process resume.
	Processor yield.
	session := DebugSession named: 'helpers' on: process startedAt: process suspendedContext.
	workspace at: #session put: session.
	self assert: ((workspace at: #frameBelow) value: 0) identicalTo: session interruptedContext.
	self assert: ((workspace at: #frameBelow) value: 1) identicalTo: session interruptedContext sender
