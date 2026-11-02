*Polyphemus-Memory
polyphemusEvaluationWith: aDebugger forRootGroup: aCommandsGroup
	"No command: on a reading, code typed in the debugger runs in the image held, else in the
	observer, said so (#126). Once built, its code pane's models are made ours as they come."
	<extensionCommands>
	(aDebugger session isKindOf: ReifiedDebugSession) ifFalse: [ ^ self ].
	aDebugger whenBuiltDo: [
		aDebugger code whenInteractionModelChangedDo: [ :model | PolyphemusContextInteractionModel takeOver: model ].
		PolyphemusContextInteractionModel takeOver: aDebugger code interactionModel ]
