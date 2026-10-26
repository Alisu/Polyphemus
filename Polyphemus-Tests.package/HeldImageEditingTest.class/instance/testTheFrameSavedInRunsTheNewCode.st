tests
testTheFrameSavedInRunsTheNewCode

	"Held in tick:, the method saved there: the frame the debugger shows the new source in must run
	that source, as Pharo's debugger restarts it, not finish with the old bytecodes (#109)."

	| pid session before after |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1' from: 0 after: 'Smalltalk at: #PolyphemusN put: n.').
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'Counter >> #tick:').
	before := (session interruptedContext tempAt: 1) asInteger.
	self assert: (session
			 recompileMethodTo: 'tick: n
	^ n > 100000 ifTrue: [ 0 ] ifFalse: [ n + 10 ]'
			 inContext: session interruptedContext
			 notifying: nil).
	5 timesRepeat: [
		session interruptedContext selector = #DoIt ifFalse: [ session stepOver: session interruptedContext ] ].
	self assert: session interruptedContext selector = #DoIt description: 'never back in the loop'.
	"Past the line that publishes n: stepping runs it, so the global is what tick: answered."
	3 timesRepeat: [ session stepOver: session interruptedContext ].
	after := (session heldProcess ask: '(Smalltalk at: #PolyphemusN) printString') copyReplaceAll: '''' with: ''.
	self
		assert: (after isAllDigits and: [ after asNumber = (before + 10) ])
		description: [ 'tick: of ' , before printString , ' answered ' , after , ': the old code ran' ].
	session resume ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
