helpers
actionModelOf: aDebugger

	"What steps and proceeds for Pharo's debugger: its action model, its client model from
	Pharo 14."

	^ (aDebugger respondsTo: #debuggerActionModel)
		  ifTrue: [ aDebugger debuggerActionModel ]
		  ifFalse: [ aDebugger debuggerClientModel ]
