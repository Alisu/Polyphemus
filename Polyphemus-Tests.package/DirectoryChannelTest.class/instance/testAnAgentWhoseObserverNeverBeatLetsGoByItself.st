tests
testAnAgentWhoseObserverNeverBeatLetsGoByItself

	"#163, risk 10, what was left of it: an observer that died before its first beat left no alive
	file, and the agent, hearing nothing, took no file for no reason to let go: held to the hour."

	| silent |
	agent terminate.
	PolyphemusAgent observerSilenceLimit: 1 second.
	[
	(directory / 'never') ensureCreateDirectory.
	silent := self agentIn: directory / 'never' limit: nil.
	silent ask: 'nil'.
	self assert: (self waitFor: [ agent isTerminated ]).
	self assert: (silent whyExpired includesSubstring: 'heard nothing') ] ensure: [
		PolyphemusAgent observerSilenceLimit: nil ]
