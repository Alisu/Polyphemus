tests
testAProcessThatWouldNotStopIsNotRead

	"What a reader answered when asked to stop the process was not looked at: a failed stop read a
	running VM as if held (#118's review)."

	| ran |
	ran := false.
	self
		should: [ ProcessMemoryThatWillNotStop new whileStopped: [ ran := true ] ]
		raise: SpurCannotRead
		withExceptionDo: [ :error | self assert: error reason equals: #itWouldNotStop ].
	self deny: ran
