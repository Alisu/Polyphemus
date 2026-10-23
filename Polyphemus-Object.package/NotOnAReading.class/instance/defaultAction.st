handling
defaultAction

	"Not handled: in the UI process, say it and abandon what asked, as Pharo does after an error there
	but without a debugger on the observer; elsewhere, an error as any other (#115)."

	UIManager default uiProcess == Processor activeProcess ifFalse: [ ^ super defaultAction ].
	UIManager default inform: self messageText.
	UIManager default spawnNewProcessIfThisIsUI: Processor activeProcess.
	Processor terminateActive
