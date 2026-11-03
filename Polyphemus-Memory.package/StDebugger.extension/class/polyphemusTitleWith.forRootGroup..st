*Polyphemus-Memory
polyphemusTitleWith: aDebugger forRootGroup: aCommandsGroup
	"No command: a debugger on a reading is made ours once built, which keeps its session's marks
	in front of its title at each step and selection (#149, #151)."
	<extensionCommands>
	(aDebugger session isKindOf: ReifiedDebugSession) ifFalse: [ ^ self ].
	aDebugger whenBuiltDo: [
		PolyphemusDebugger takeOver: aDebugger.
		aDebugger session markTitleOf: aDebugger ]
