tests
testAReadRunningPastARangeAnswersNothing

	| dump |
	dump := WindowsMinidump on: dumpFile.
	self assert: (dump bytesAt: 16r100000000F8 count: 8) size equals: 8.
	self assert: (dump bytesAt: 16r100000000FC count: 8) isNil
