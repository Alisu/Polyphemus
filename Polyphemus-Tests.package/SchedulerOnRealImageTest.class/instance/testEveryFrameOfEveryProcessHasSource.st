tests
testEveryFrameOfEveryProcessHasSource

	"A clean image knows where all of its source is. A frame without source means
	either a damaged method or the wrong sources file, and both are worth failing on."

	reifiedMemory allReifiedProcesses do: [ :process |
		(reifiedMemory contextsOfProcess: process) do: [ :context |
			self deny: (reifiedMemory sourceOfContext: context) isNil ] ]
