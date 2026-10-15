tests
testAPidThatIsNoProcessIsRefusedSayingSo

	self
		should: [ WindowsProcessMemory on: 999999999 ]
		raise: CannotReadProcess
		withExceptionDo: [ :e | self assert: e reason equals: #noSuchProcess ]
