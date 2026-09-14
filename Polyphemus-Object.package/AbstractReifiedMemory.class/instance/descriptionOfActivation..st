contexts
descriptionOfActivation: anActivation

	"One line for a frame or for a context: they are the same activation in two forms, and
	a stack that mixes them should not read as though it does."

	^ anActivation isStackFrame
		  ifTrue: [ self descriptionOfFrame: anActivation ]
		  ifFalse: [ self descriptionOfContext: anActivation ]
