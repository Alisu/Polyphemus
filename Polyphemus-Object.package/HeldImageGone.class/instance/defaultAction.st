handling
defaultAction

	"Not handled: in the UI process, ask what to do with the debugger and abandon what asked, as a
	refusal does (NotOnAReading); elsewhere, an error as any other."

	UIManager default uiProcess == Processor activeProcess ifFalse: [ ^ super defaultAction ].
	self tellAbout: self frontDebugger.
	UIManager default spawnNewProcess.
	Processor terminateActive
