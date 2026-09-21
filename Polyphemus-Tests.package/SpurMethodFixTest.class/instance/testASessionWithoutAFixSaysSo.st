tests
testASessionWithoutAFixSaysSo

	"A memory opened for reading answers the accept with a no rather than a mess."

	| context session |
	context := (reading contextsOfProcess: (Polyphemus deepestProcessIn: reading)) first.
	session := ReifiedDebugSession named: 'Polyphemus' on: nil startedAt: context.

	self deny: (session fixMethodOf: context to: 'whatever ^ 1' notifying: nil)
