tests
testARefusalIsSaidInAMessageThatWaitsForOK

	"#142: said in a message that stays until OK, not one that fades."

	| ui |
	ui := UIManagerDouble new.
	(NotOnAReading new messageText: 'Restart is not supported on a held image yet'; yourself) tellWith: ui.
	self assert: ui alerts asArray equals: { 'Refused' -> 'Restart is not supported on a held image yet' }
