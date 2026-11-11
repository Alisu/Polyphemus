tests
testAStopThatFailsLetsTheImageGoAllTheSame

	"#170: Stop's request failed, and its error came back before the image was let go: held on."

	| session letGo |
	letGo := false.
	session := ReifiedDebugSession new.
	session instVarNamed: 'held' put: StopRefusingDouble new.
	session instVarNamed: 'release' put: [ letGo := true ].
	self should: [ session stopTheHeldProcess ] raise: Error.
	self assert: letGo
