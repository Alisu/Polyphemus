tests
testFrameBelowCountsFromTheDebuggersFrame

	| session |
	self waiting.
	session := DebugSession named: 'helpers' on: process startedAt: process suspendedContext.
	workspace at: #session put: session.
	self assert: ((workspace at: #frameBelow) value: 0) identicalTo: session interruptedContext.
	self assert: ((workspace at: #frameBelow) value: 1) identicalTo: session interruptedContext sender
