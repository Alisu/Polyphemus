commands
stDebuggerCommandsWith: aDebugger forRootGroup: aCommandsGroup

	"Pharo collects extension commands from the debugger's own class only: StDebugger's, ours among them."
	<extensionCommands>
	StDebugger buildExtensionCommandsWith: aDebugger forRoot: aCommandsGroup
