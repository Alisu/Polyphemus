tests
testSteppingIntoAHaltStopsThereAndTheImageStepsOn

	"#170, #171: a halt reached by stepping, not by an evaluation, is Pharo's debugger's to stop
	at; it runs in our request all the same, which must not wait on the held UI process."

	| pid session path step |
	pid := self launchTargetDefining: 'Counter' thenRunning: (self counterTicking: 'tick: n
	^ (Smalltalk at: #PolyphemusHaltHere ifAbsent: [ false ])
		ifTrue: [ self halt. 0 ]
		ifFalse: [ n + 1 ]' from: 41 after: '').
	[
	session := self heldAtTickOf: pid.
	session evaluate: 'Smalltalk at: #PolyphemusHaltHere put: true' in: session interruptedContext.
	path := OrderedCollection new.
	step := [ :how |
	        | started context |
	        context := session interruptedContext.
	        started := Time millisecondClockValue.
	        [ session perform: how with: context ] on: Error do: [ :error | path add: error messageText ].
	        self assert: Time millisecondClockValue - started < 20000 description: [ 'a step was waited on, after ' , path asArray printString ].
	        path add: session interruptedContext selector ].
	[ (path includesAny: #( #halt #now )) or: [ path size > 16 ] ] whileFalse: [
		| node |
		node := [ session interruptedContext sourceNodeExecuted ] on: Error do: [ :error | nil ].
		step value: ((session interruptedContext selector = #tick: and: [
			  node notNil and: [ node isMessage and: [ node selector = #halt ] ] ])
			 ifTrue: [ #stepInto: ]
			 ifFalse: [ #stepOver: ]) ].
	"Stepped into Object>>halt, or, where the frame does not show the halt as its next node (Pharo
	10), over a call that halts: Pharo's debugger stops in Halt class>>now either way."
	self assert: (path includesAny: #( #halt #now )) description: [ 'never stepped to the halt: ' , path asArray printString ].
	3 timesRepeat: [ step value: #stepOver: ].
	self assert: (session evaluate: '3 + 4' in: session interruptedContext) printed equals: '7' ] ensure: [
		LibC system: 'kill -9 ' , pid printString ]
