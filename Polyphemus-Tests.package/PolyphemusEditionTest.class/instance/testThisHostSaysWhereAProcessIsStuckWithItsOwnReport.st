tests
testThisHostSaysWhereAProcessIsStuckWithItsOwnReport

	"Polyphemus whereIsStuck: asks the host package which report: /proc on Linux, the task port
	and its threads on macOS."

	self
		assert: PolyphemusMadeFor current stuckReportClass name
		equals: (PolyphemusHost current os = 'MacOS'
				 ifTrue: [ #MacStuckReport ]
				 ifFalse: [ #StuckReport ])
