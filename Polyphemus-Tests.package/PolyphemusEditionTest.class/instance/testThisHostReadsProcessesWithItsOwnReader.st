tests
testThisHostReadsProcessesWithItsOwnReader

	"Polyphemus readProcess: asks the host package which reader: /proc on Linux, the task port on
	macOS."

	self
		assert: PolyphemusMadeFor current processMemoryClass name
		equals: (PolyphemusHost current os = 'MacOS'
				 ifTrue: [ #MacProcessMemory ]
				 ifFalse: [ #LinuxProcessMemory ])
