*Polyphemus-Memory
defaultAction

	"Not handled, with the windows loaded: in the UI process, ask what to do with the debugger and
	abandon what asked, as a refusal does (NotOnAReading); elsewhere, an error as any other."

	UIManager default uiProcess == Processor activeProcess ifFalse: [ ^ super defaultAction ].
	self tellAbout: PolyphemusDebugger inFront.
	UIManager default spawnNewProcess.
	Processor terminateActive
