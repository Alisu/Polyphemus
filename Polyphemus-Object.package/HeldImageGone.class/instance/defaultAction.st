handling
defaultAction

	"Not handled: in the UI process, say it and abandon what asked, as a refusal does (NotOnAReading);
	elsewhere, an error as any other."

	UIManager default uiProcess == Processor activeProcess ifFalse: [ ^ super defaultAction ].
	UIManager default inform: self messageText.
	UIManager default spawnNewProcessIfThisIsUI: Processor activeProcess.
	Processor terminateActive
