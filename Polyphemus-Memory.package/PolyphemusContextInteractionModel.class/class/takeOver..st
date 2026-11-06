installing
takeOver: anInteractionModel

	"Makes the model the debugger just gave its code pane, on a frame read, one of ours in place:
	replaced inside Pharo's notice of the change, Pharo's own would land after ours."

	(anInteractionModel class == StDebuggerContextInteractionModel and: [ anInteractionModel context isReadActivation ])
		ifTrue: [ self adoptInstance: anInteractionModel ]
