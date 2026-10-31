tests
testARefusalWithNoPaneIsSaidInAMessageThatWaitsForOK

	"#142: with no code pane to point into, said in a message that stays until OK."

	| ui save |
	ui := UIManagerDouble new.
	save := (MethodSave of: 'tick: n ^ n + 1' notifying: nil) ui: ui; yourself.
	self deny: (save refuse: 'only read').
	self assert: ui alerts asArray equals: { 'Not saved' -> 'only read' }
