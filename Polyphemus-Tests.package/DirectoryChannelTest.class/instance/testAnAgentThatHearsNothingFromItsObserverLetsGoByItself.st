tests
testAnAgentThatHearsNothingFromItsObserverLetsGoByItself

	"#163, risk 10: an observer dying while its agent served left the image held up to the hour
	limit. Its heartbeat older than the silence limit, the agent lets go, and says why."

	| silent |
	agent terminate.
	PolyphemusAgent observerSilenceLimit: 1 second.
	[
	(directory / 'silent') ensureCreateDirectory.
	(directory / 'silent' / 'alive') ensureCreateFile.
	silent := self agentIn: directory / 'silent' limit: nil.
	silent ask: 'nil'.
	self assert: (self waitFor: [ agent isTerminated ]).
	self assert: (silent whyExpired includesSubstring: 'heard nothing') ] ensure: [
		PolyphemusAgent observerSilenceLimit: nil ]
