tests
testThisHostReadsProcessesWithItsOwnReader

	"Polyphemus readProcess: asks the host package which reader: /proc on Linux, the task port on
	macOS, ReadProcessMemory on Windows."

	(PolyphemusHost current os = 'Windows' and: [ (Smalltalk hasClassNamed: #WindowsProcessMemory) not ])
		ifTrue: [ ^ self skip: 'no reader of Windows processes yet (docs/handover-windows.md, step 5)' ].
	self
		assert: PolyphemusMadeFor current processMemoryClass name
		equals: ({
				 ('Linux' -> #LinuxProcessMemory).
				 ('MacOS' -> #MacProcessMemory).
				 ('Windows' -> #WindowsProcessMemory) } asDictionary at: PolyphemusHost current os)
