tests
testASaveThatDoesNotCompileIsToldWhereTheCompilerSays

	"A source that parses but does not compile, an argument assigned: told with the compiler's own
	reason where it points, apart from the code, not as 'does not compile' glued to its start."

	| pid session notifier source |
	((OpalCompiler new source: 'a ^ 1'; parse) respondsTo: #allNotices) ifFalse: [
		^ self skip: 'this Pharo compiles an assignment to an argument' ].
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1').
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'Counter >> #tick:').
	notifier := NotifierDouble new.
	source := 'tick: n
	n := 3.
	^ n + 1'.
	self deny: (session recompileMethodTo: source inContext: session interruptedContext notifying: notifier).
	self assert: notifier notices size equals: 1.
	self assert: notifier notices first last equals: (source indexOfSubCollection: 'n :=').
	self assert: (notifier notices first first includesSubstring: 'read-only').
	self assert: (notifier notices first first endsWith: ' ->').
	session resume ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
