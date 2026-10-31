tests
testAPartlySavedMethodIsSaidInAMessageThatWaitsForOK

	"#142: the method is in, its source or restart missing: said in a message that stays until OK,
	not one that fades, as what was left undone can matter later (#119)."

	| ui save |
	ui := UIManagerDouble new.
	save := (MethodSave of: 'tick: n ^ n + 1' notifying: notifier) ui: ui; yourself.
	save writeWith: [ PartlySaved signal: 'saved, but its source was not kept' ].
	self assert: ui alerts asArray equals: { 'Saved, but not all of it' -> 'saved, but its source was not kept' }
