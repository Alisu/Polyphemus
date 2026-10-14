tests
testThisHostSaysWhereAProcessIsStuckWithItsOwnReport

	"Polyphemus whereIsStuck: asks the host package which report: /proc on Linux, the task port
	and its threads on macOS, the threads' contexts on Windows."

	(PolyphemusHost current os = 'Windows' and: [ (Smalltalk hasClassNamed: #WindowsStuckReport) not ])
		ifTrue: [ ^ self skip: 'no stuck report of Windows processes yet (docs/handover-windows.md, step 5)' ].
	self
		assert: PolyphemusMadeFor current stuckReportClass name
		equals: ({
				 ('Linux' -> #StuckReport).
				 ('MacOS' -> #MacStuckReport).
				 ('Windows' -> #WindowsStuckReport) } asDictionary at: PolyphemusHost current os)
