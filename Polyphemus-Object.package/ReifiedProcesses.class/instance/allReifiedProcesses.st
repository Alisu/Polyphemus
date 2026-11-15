scheduler
allReifiedProcesses

	"Every process, found by the class of the one that was running -- the scheduler only knows
	the queued ones, and the class name differs (PCProcess, Process). Refused by name where what
	is said to be running is no object, or its class does not read."

	| active class |
	active := self reifiedActiveProcess.
	class := (active isKindOf: OOPAbstractObject) ifTrue: [ active oopClass ].
	(class notNil and: [ class isClassOop ]) ifFalse: [
		^ NotInTheReading signal: 'the processes are found by the class of the one that was running, which does not read: '
			  , active whatItReadsAs ].
	^ class instancesOop
