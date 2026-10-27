tests
testASaveRemembersNoYoungObject

	"The remembered set holds old objects only; a save into a class made at run time, its method
	array still young, must not put that array there (a lead for #119)."

	| pid session held young remembered |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ n + 1').
	[
	Polyphemus putAWatcherInto: pid watchedIn: self spikeDirectory.
	session := Polyphemus holdProcess: pid watchedIn: self spikeDirectory.
	self assert: (session runUntil: 'Counter >> #tick:').
	held := session heldProcess heldReading.
	young := held
		         whileStillWhereRead: session interruptedContext homeMethod
		         do: [ :memory | self isYoung: (self methodArrayOf: session interruptedContext homeMethod) in: memory ].
	session recompileMethodTo: 'tick: n
	^ n + 1000' inContext: session interruptedContext notifying: nil.
	remembered := held whileStillWhereRead: session heldProcess context do: [ :memory | self youngRememberedIn: memory ].
	self assert: remembered isEmpty description: [ 'young objects remembered: ' , remembered printString ].
	young ifFalse: [ self skip: 'Counter''s method array was already old: nothing young was saved into' ].
	session resume ] ensure: [ LibC system: 'kill -9 ' , pid printString ]
