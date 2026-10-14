tests
testThisHostReadsProcessesWithItsOwnReader

	"Polyphemus readProcess: asks the host package which reader: /proc on Linux, the task port on
	macOS, ReadProcessMemory on Windows."

	self
		assert: PolyphemusMadeFor current processMemoryClass name
		equals: ({
				 ('Linux' -> #LinuxProcessMemory).
				 ('MacOS' -> #MacProcessMemory).
				 ('Windows' -> #WindowsProcessMemory) } asDictionary at: PolyphemusHost current os)
