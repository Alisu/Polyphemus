tests
testAWriteThatStoppedAfterTheMethodWasInIsSaved

	"The method is in the image, its source or its restart missing: the pane keeps it as saved,
	the error not shown in its code, and the message says what was done."

	| save |
	save := (MethodSave of: 'tick: n ^ n + 1' notifying: notifier) ui: UIManagerDouble new; yourself.
	self assert: (save writeWith: [ PartlySaved signal: 'saved, but its source was not kept' ]).
	self assert: notifier notices isEmpty.
	self assert: save told equals: 'saved, but its source was not kept'
