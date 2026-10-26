tests
testADebuggerDoneWithAHeldImageKeepsNoReadingOfIt

	"Pharo's theme keeps the last debugger, its action model a context of ours, and Pharo 10's AST
	cache the methods compiled for a reading: each kept the reading, Pharo 10 ran out of memory (#110)."

	| pid session debugger readings |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1').
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	#( #proceeded #closed ) do: [ :how |
		(self spikeDirectory / 'released') ensureDelete.
		session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
		self assert: (session runUntil: 'Counter >> #tick:').
		debugger := StDebugger openOn: session withFullView: true.
		PolyphemusTestCase drawWindowOf: debugger.
		readings := WeakArray with: session heldProcess dumped with: session heldProcess reading memoryManager.
		how = #proceeded ifTrue: [ (PolyphemusTestCase actionModelOf: debugger) proceedDebugSession ].
		debugger window ifNotNil: [ :window | window close ].
		debugger := nil.
		self
			assert: ((1 to: 200) anySatisfy: [ :each |
					 (self spikeDirectory / 'released') exists or: [ (Delay forMilliseconds: 100) wait. false ] ])
			description: 'the image was never let go'.
		Smalltalk garbageCollect.
		self
			assert: (readings allSatisfy: [ :each | each isNil ])
			description: [ how , ', the session still holds ' , readings asArray printString ].
		(ASTCache default respondsTo: #keys) ifTrue: [
			self
				deny: (ASTCache default keys anySatisfy: [ :each | each methodClass isKindOf: OOPAbstractClass ])
				description: how , ', Pharo''s AST cache keeps methods compiled for the reading' ] ] ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
