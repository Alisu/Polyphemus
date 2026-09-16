tests
testItSaysWhatYamaIsSetTo

	"Because every refusal to read another process comes back to this number, and someone
	reading the message needs to be able to check it."

	self assert: LinuxProcessMemory ptraceScope isNotNil.
	self assert: (LinuxProcessMemory ptraceScope between: 0 and: 3)
