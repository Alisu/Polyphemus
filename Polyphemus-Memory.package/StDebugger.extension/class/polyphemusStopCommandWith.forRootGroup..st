*Polyphemus-Memory
polyphemusStopCommandWith: aDebugger forRootGroup: aCommandsGroup

	"Stop in the toolbar, for the debugger of a held image only (#125)."

	<extensionCommands>
	([ aDebugger session heldProcess ] on: MessageNotUnderstood do: [ :e | nil ]) ifNil: [ ^ self ].
	aCommandsGroup / StDebuggerToolbarCommandTreeBuilder groupName register: (PolyphemusStopCommand forSpecContext: aDebugger)
