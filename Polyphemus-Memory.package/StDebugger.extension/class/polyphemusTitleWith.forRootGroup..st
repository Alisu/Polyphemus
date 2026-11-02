*Polyphemus-Memory
polyphemusTitleWith: aDebugger forRootGroup: aCommandsGroup
	"No command: the marks of a session on a reading go in front of its debugger's title once it is
	built (#149). Pharo sets the title anew at each step and selection, which drops them (#151)."
	<extensionCommands>
	(aDebugger session isKindOf: ReifiedDebugSession) ifFalse: [ ^ self ].
	aDebugger whenBuiltDo: [ aDebugger session markTitleOf: aDebugger ]
